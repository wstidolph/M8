import 'answer.dart';

/// Interface for components providing sets of mystical answers.
abstract class AnswerSource {
  /// Retrieves a list of answers from the provider.
  Future<List<Answer>> getAnswers();
  
  /// A unique identifier for the source (e.g., 'classic', 'supabase').
  String get sourceId;
}
