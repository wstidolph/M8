import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/orb_state.dart';
import '../infrastructure/sensor_service.dart';

/// State of the Orb animation including physics parameters and current visual state.
class OrbAnimationState {
  final OrbState state;
  final double turbulence;
  final String? revealedAnswer;

  const OrbAnimationState({
    this.state = OrbState.idle,
    this.turbulence = 0.0,
    this.revealedAnswer,
  });

  OrbAnimationState copyWith({
    OrbState? state,
    double? turbulence,
    String? revealedAnswer,
  }) {
    return OrbAnimationState(
      state: state ?? this.state,
      turbulence: turbulence ?? this.turbulence,
      revealedAnswer: revealedAnswer ?? this.revealedAnswer,
    );
  }
}

/// Controller for the M8 orb simulation, handling sensor triggers and orchestration.
class OrbController extends StateNotifier<OrbAnimationState> {
  final SensorService _sensorService;
  StreamSubscription? _sensorSub;
  Timer? _dampeningTimer;
  Timer? _dismissalTimer;

  OrbController(this._sensorService) : super(const OrbAnimationState());

  void init() {
    _sensorSub = _sensorService.shakeIntensityStream.listen((intensity) {
      _handleSensorInput(intensity);
    });
  }

  void _handleSensorInput(ShakeIntensity intensity) {
    // Clear existing timers when new motion starts
    _dampeningTimer?.cancel();
    _dismissalTimer?.cancel();
    
    switch (intensity) {
      case ShakeIntensity.violent:
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
    state = state.copyWith(state: OrbState.revealing);
    
    // Simulate short animation before presenting
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        state = state.copyWith(
          state: OrbState.presenting,
          revealedAnswer: "IT IS CERTAIN", // Sample answer for Phase 2
        );
        
        // Start auto-dismissal timer (as per research.md: 7s)
        _dismissalTimer = Timer(const Duration(seconds: 7), () {
           if (mounted) _dismissAnswer();
        });
      }
    });
  }

  void _dismissAnswer() {
    state = state.copyWith(
      state: OrbState.idle,
      revealedAnswer: null,
      turbulence: 0.0,
    );
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
