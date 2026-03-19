import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/orb_state.dart';
import '../infrastructure/sensor_service.dart';
import '../../responses/domain/orb_mood.dart';
import '../../responses/domain/answer.dart';
import '../../responses/application/response_engine.dart';
import '../../responses/infrastructure/answer_repository.dart';

/// State of the Orb animation including physics parameters and current visual state.
class OrbAnimationState {
  final OrbState state;
  final double turbulence;
  final String? revealedAnswer;
  final List<String> history;
  final bool showHistory;

  const OrbAnimationState({
    this.state = OrbState.idle,
    this.turbulence = 0.0,
    this.revealedAnswer,
    this.history = const [],
    this.showHistory = false,
  });

  OrbAnimationState copyWith({
    OrbState? state,
    double? turbulence,
    String? revealedAnswer,
    List<String>? history,
    bool? showHistory,
  }) {
    return OrbAnimationState(
      state: state ?? this.state,
      turbulence: turbulence ?? this.turbulence,
      revealedAnswer: revealedAnswer ?? this.revealedAnswer,
      history: history ?? this.history,
      showHistory: showHistory ?? this.showHistory,
    );
  }
}

/// Controller for the M8 orb simulation, handling sensor triggers and orchestration.
class OrbController extends StateNotifier<OrbAnimationState> {
  final SensorService _sensorService;
  final ResponseEngine _engine = ResponseEngine();
  final AnswerRepository _repository = AnswerRepository();
  List<Answer> _answerPool = [];

  StreamSubscription? _sensorSub;
  Timer? _dampeningTimer;
  Timer? _dismissalTimer;
  DateTime? _lastInteractionEnd;

  OrbController(this._sensorService) : super(const OrbAnimationState()) {
    _initializeAnswers();
  }

  Future<void> _initializeAnswers() async {
    // 1. Load initial pool (classic/cached)
    _answerPool = await _repository.getActivePool();
    
    // 2. Trigger background sync
    await _repository.syncRemote();
    
    // 3. Update pool after sync
    _answerPool = await _repository.getActivePool();
  }

  void init() {
    _sensorService.init();
    _sensorSub = _sensorService.shakeIntensityStream.listen((intensity) {
      _handleSensorInput(intensity);
    });
  }

  Future<void> refreshAnswers() async {
    _answerPool = await _repository.getActivePool();
  }

  void _handleSensorInput(ShakeIntensity intensity) {
    // 1. Workflow [/sensor-calibration]: Debounce after interaction (500ms)
    final now = DateTime.now();
    if (_lastInteractionEnd != null && now.difference(_lastInteractionEnd!) < const Duration(milliseconds: 500)) {
      return;
    }

    // 2. Ignore sensors if already presenting an answer
    if (state.state == OrbState.presenting || state.state == OrbState.revealing) {
      return;
    }

    // Clear existing timers when new motion starts
    _dampeningTimer?.cancel();
    _dismissalTimer?.cancel();
    
    switch (intensity) {
      case ShakeIntensity.violent:
        HapticFeedback.heavyImpact();
        state = state.copyWith(
          state: OrbState.chaotic,
          turbulence: 1.0,
        );
        break;
      case ShakeIntensity.light:
        // Transition from idle/revealing to turbulent
        if (state.state != OrbState.chaotic) {
          state = state.copyWith(
            state: OrbState.turbulent,
            turbulence: 0.5,
          );
        }
        break;
      case ShakeIntensity.none:
        // Trigger dampening/settling logic if motion stops
        if (state.state == OrbState.turbulent || state.state == OrbState.chaotic) {
          _startDampening();
        }
        break;
    }
  }

  void _startDampening() {
    // Elastic dampening period (as per research.md: 500-1000ms)
    _dampeningTimer = Timer(const Duration(milliseconds: 750), () {
      if (state.state == OrbState.turbulent) {
        state = state.copyWith(state: OrbState.idle, turbulence: 0.0);
      } else if (state.state == OrbState.chaotic) {
        _triggerAnswerReveal();
      }
    });
  }

  void _triggerAnswerReveal() {
    if (_answerPool.isEmpty) return;
    
    // 1. Select answer using engine and current "mood" (based on turbulence)
    final mood = state.turbulence > 0.8 ? OrbMood.energetic : OrbMood.idle;
    final selected = _engine.selectAnswer(_answerPool, mood);

    // 2. Update history
    final updatedHistory = [selected.text, ...state.history].take(10).cast<String>().toList();
    
    state = state.copyWith(
      state: OrbState.revealing,
      history: updatedHistory,
    );

    // Simulate short animation before presenting
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        HapticFeedback.selectionClick();
        state = state.copyWith(
          state: OrbState.presenting,
          revealedAnswer: selected.text,
        );
        
        // Start auto-dismissal timer (as per research.md: 7s)
        _dismissalTimer = Timer(const Duration(seconds: 7), () {
           if (mounted) _dismissAnswer();
        });
      }
    });
  }

  void _dismissAnswer() {
    _lastInteractionEnd = DateTime.now();
    state = state.copyWith(
      state: OrbState.idle,
      revealedAnswer: null,
      turbulence: 0.0,
    );
  }

  void toggleHistory() {
    state = state.copyWith(showHistory: !state.showHistory);
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    _dampeningTimer?.cancel();
    _dismissalTimer?.cancel();
    super.dispose();
  }
}

/// Provider for the OrbController.
final orbControllerProvider = StateNotifierProvider<OrbController, OrbAnimationState>((ref) {
  final service = SensorService();
  return OrbController(service)..init();
});
