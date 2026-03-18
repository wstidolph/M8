library;

import 'answer.dart';

/// System-wide state influencing selection probability.
enum OrbMood {
  /// Default state (x1.0 for all)
  idle,
  /// Twice as likely to be positive (x2.0 for positive)
  energetic,
  /// Twice as likely to be negative (x2.0 for negative)
  gloomy,
}

extension OrbMoodExtension on OrbMood {
  double getWeightMultiplier(AnswerCategory category) {
    if (this == OrbMood.energetic && category == AnswerCategory.positive) return 2.0;
    if (this == OrbMood.gloomy && category == AnswerCategory.negative) return 2.0;
    return 1.0;
  }
}
