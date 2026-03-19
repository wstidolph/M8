import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/answer.dart';
import '../../domain/answer_source.dart';

/// Fetches dynamic answers from a Supabase 'dynamic_answers' table.
class SupabaseAnswerProvider implements AnswerSource {
  @override
  String get sourceId => 'supabase';

  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<List<Answer>> getAnswers() async {
    try {
      // Lazy access to the initialized client
      final List<dynamic> data = await _client
          .from('dynamic_answers')
          .select()
          .eq('is_active', true);

      return data.map((json) => Answer(
        text: json['text'] as String,
        category: AnswerCategory.values.byName(json['category'] as String),
        baseWeight: (json['weight'] as num?)?.toDouble() ?? 1.0,
        isEvent: json['is_event'] as bool? ?? false,
        source: sourceId,
      )).toList();
    } catch (e) {
      // Silent error - will fallback to local set in repository
      return [];
    }
  }
}
