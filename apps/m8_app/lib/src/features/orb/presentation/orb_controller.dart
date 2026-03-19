import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/orb_state.dart';
import '../infrastructure/sensor_service.dart';
import '../../responses/domain/orb_mood.dart';
import '../../responses/domain/answer.dart';
import '../../responses/application/response_engine.dart';
import '../../responses/infrastructure/answer_repository.dart';

import 'components/answer_visual.dart';

/// State of the Orb animation including physics parameters and current visual state.
class OrbAnimationState {
  final OrbState state;
  final double turbulence;
  final String? revealedAnswer;
  final List<String> history;
  final bool showHistory;
  final double revealSeed;
  final int manifestationClock; 
  final OrbContainerShape containerShape;
  final double nebulaIntensity;

  const OrbAnimationState({
    this.state = OrbState.idle,
    this.turbulence = 0.0,
    this.revealedAnswer,
    this.history = const [],
    this.showHistory = false,
    this.revealSeed = 0.0,
    this.manifestationClock = 0,
    this.containerShape = OrbContainerShape.triangle,
    this.nebulaIntensity = 0.25,
  });

  OrbAnimationState copyWith({
    OrbState? state,
    double? turbulence,
    String? revealedAnswer,
    List<String>? history,
    bool? showHistory,
    double? revealSeed,
    int? manifestationClock,
    OrbContainerShape? containerShape,
    double? nebulaIntensity,
  }) {
    return OrbAnimationState(
      state: state ?? this.state,
      turbulence: turbulence ?? this.turbulence,
      revealedAnswer: revealedAnswer ?? this.revealedAnswer,
      history: history ?? this.history,
      showHistory: showHistory ?? this.showHistory,
      revealSeed: revealSeed ?? this.revealSeed,
      manifestationClock: manifestationClock ?? this.manifestationClock,
      containerShape: containerShape ?? this.containerShape,
      nebulaIntensity: nebulaIntensity ?? this.nebulaIntensity,
    );
  }
}

class OrbController extends StateNotifier<OrbAnimationState> {
  final SensorService _sensorService;
  final ResponseEngine _engine = ResponseEngine();
  final AnswerRepository _repository = AnswerRepository();
  List<Answer> _answerPool = [];

  StreamSubscription? _sensorSub;
  Timer? _dampeningTimer;
  Timer? _dismissalTimer;

  OrbController(this._sensorService) : super(const OrbAnimationState()) {
    _initializeAnswers();
  }

  Future<void> _initializeAnswers() async {
    _answerPool = await _repository.getActivePool();
    try {
      await _repository.syncRemote().timeout(const Duration(seconds: 3));
      _answerPool = await _repository.getActivePool();
    } catch (_) {}
  }

  void init() {
    _sensorService.init();
    _sensorSub = _sensorService.shakeIntensityStream.listen(_handleSensorInput);
  }

  Future<void> refreshAnswers() async {
    _answerPool = await _repository.getActivePool();
  }

  void _handleSensorInput(ShakeIntensity intensity) {
    if (state.state == OrbState.presenting || state.state == OrbState.revealing) return;
    _cleanupTimers();
    
    switch (intensity) {
      case ShakeIntensity.violent:
        HapticFeedback.heavyImpact();
        state = state.copyWith(state: OrbState.chaotic, turbulence: 1.0, nebulaIntensity: 0.85);
        break;
      case ShakeIntensity.light:
        if (state.state != OrbState.chaotic) {
          state = state.copyWith(state: OrbState.turbulent, turbulence: 0.5, nebulaIntensity: 0.65);
        }
        break;
      case ShakeIntensity.none:
        if (state.state == OrbState.turbulent || state.state == OrbState.chaotic) {
          _startDampening();
        }
        break;
    }
  }

  void _cleanupTimers() {
    _dampeningTimer?.cancel();
    _dismissalTimer?.cancel();
  }

  void _startDampening() {
    final currentClock = state.manifestationClock;
    _dampeningTimer = Timer(const Duration(milliseconds: 750), () {
      if (!mounted || state.manifestationClock != currentClock) return;
      if (state.state == OrbState.turbulent) {
        state = state.copyWith(state: OrbState.idle, turbulence: 0.0, nebulaIntensity: 0.25);
      } else if (state.state == OrbState.chaotic) {
        _triggerAnswerReveal();
      }
    });
  }

  void _triggerAnswerReveal() {
    if (_answerPool.isEmpty) return;
    
    final currentClock = state.manifestationClock;
    final mood = state.turbulence > 0.8 ? OrbMood.energetic : OrbMood.idle;
    final selected = _engine.selectAnswer(_answerPool, mood);
    
    state = state.copyWith(
      state: OrbState.revealing,
      revealedAnswer: selected.text,
      history: [selected.text, ...state.history].take(10).cast<String>().toList(),
      nebulaIntensity: 1.0, 
    );

    _animateNebulaDampening();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (!mounted || state.manifestationClock != currentClock) return;
      
      HapticFeedback.selectionClick();
      state = state.copyWith(
        state: OrbState.presenting,
        nebulaIntensity: 0.4,
      );
      
      _dismissalTimer = Timer(const Duration(seconds: 7), () {
        if (mounted && state.manifestationClock == currentClock) _dismissAnswer();
      });
    });
  }

  void _animateNebulaDampening() {
    final startClock = state.manifestationClock;
    const duration = Duration(milliseconds: 3500);
    const interval = Duration(milliseconds: 32);
    int elapsed = 0;

    Timer.periodic(interval, (timer) {
      if (!mounted || state.manifestationClock != startClock || state.state != OrbState.revealing) {
        timer.cancel();
        return;
      }

      elapsed += interval.inMilliseconds;
      final progress = (elapsed / duration.inMilliseconds).clamp(0.0, 1.0);
      final curvedProgress = 1.0 - math.pow(1.0 - progress, 3);
      final newIntensity = 1.0 - (curvedProgress * 0.6);
      
      state = state.copyWith(nebulaIntensity: newIntensity);

      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  void _dismissAnswer() {
    state = state.copyWith(
      state: OrbState.idle,
      revealedAnswer: null,
      turbulence: 0.0,
      nebulaIntensity: 0.25,
    );
  }

  void simulateManualShake() {
    _cleanupTimers();
    final newClock = state.manifestationClock + 1;
    state = state.copyWith(
      state: OrbState.chaotic,
      turbulence: 1.0,
      revealedAnswer: null,
      revealSeed: math.Random().nextDouble(), 
      manifestationClock: newClock, 
      nebulaIntensity: 0.9, // Ultra vivid start
    );
    _startDampening();
  }

  void toggleHistory() {
    state = state.copyWith(showHistory: !state.showHistory);
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    _cleanupTimers();
    super.dispose();
  }
}

final orbControllerProvider = StateNotifierProvider<OrbController, OrbAnimationState>((ref) {
  final service = SensorService();
  return OrbController(service)..init();
});
