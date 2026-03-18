library;

/// Represents the visual and physical state of the mystical M8 orb.
enum OrbState {
  /// Subtle "breathing" liquid animation with gentle waves.
  idle,

  /// Reactive, frequent waves triggered by a "Light Shake".
  turbulent,

  /// Chaotic, splashing liquid motion triggered by a "Violent Shake".
  chaotic,

  /// Transition state where the liquid starts settling to reveal the answer.
  revealing,

  /// Visual display state where the answer triangle and text are visible.
  presenting,
}

/// Domain model for the physics parameters of a single wave layer.
class WaveLayer {
  final double frequency;
  final double amplitude;
  final double phaseOffset;
  final double fillLevel;

  const WaveLayer({
    required this.frequency,
    required this.amplitude,
    required this.phaseOffset,
    this.fillLevel = 0.5,
  });

  WaveLayer copyWith({
    double? frequency,
    double? amplitude,
    double? phaseOffset,
    double? fillLevel,
  }) {
    return WaveLayer(
      frequency: frequency ?? this.frequency,
      amplitude: amplitude ?? this.amplitude,
      phaseOffset: phaseOffset ?? this.phaseOffset,
      fillLevel: fillLevel ?? this.fillLevel,
    );
  }
}
