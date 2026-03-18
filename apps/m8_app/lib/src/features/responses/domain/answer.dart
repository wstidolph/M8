library;

/// Represents the response type for categorization and weighting.
enum AnswerCategory {
  /// Affirmative answers
  positive,
  /// Uncertain or neutral answers
  neutral,
  /// Negative or discouraging answers
  negative,
}

/// Domain model for a mystical response.
class Answer {
  final String text;
  final AnswerCategory category;
  final double baseWeight;
  final bool isEvent;
  final String source;

  const Answer({
    required this.text,
    required this.category,
    this.baseWeight = 1.0,
    this.isEvent = false,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'category': category.name,
    'weight': baseWeight,
    'is_event': isEvent,
    'source': source,
  };

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'] as String,
      category: AnswerCategory.values.byName(json['category'] as String),
      baseWeight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      isEvent: json['is_event'] as bool? ?? false,
      source: json['source'] as String? ?? 'local',
    );
  }
}
