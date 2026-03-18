import 'package:flutter_test/flutter_test.dart';
import 'package:m8_app/src/features/responses/domain/answer.dart';
import 'package:m8_app/src/features/responses/domain/orb_mood.dart';
import 'package:m8_app/src/features/responses/application/response_engine.dart';

void main() {
  group('ResponseEngine Weighting Tests', () {
    final engine = ResponseEngine();
    final pool = [
      const Answer(text: 'Positive', category: AnswerCategory.positive, source: 'test'),
      const Answer(text: 'Neutral', category: AnswerCategory.neutral, source: 'test'),
      const Answer(text: 'Negative', category: AnswerCategory.negative, source: 'test'),
    ];

    test('Selection distribution biases correctly for Energetic mood', () {
      final counts = <AnswerCategory, int>{
        AnswerCategory.positive: 0,
        AnswerCategory.neutral: 0,
        AnswerCategory.negative: 0,
      };

      const trials = 1000;
      for (int i = 0; i < trials; i++) {
        final selected = engine.selectAnswer(pool, OrbMood.energetic);
        counts[selected.category] = (counts[selected.category] ?? 0) + 1;
      }

      print('Energetic Counts: $counts');
      
      // Expected: Positive should be approx twice as frequent as Neutral or Negative
      // Total weight: 2.0 (Pos) + 1.0 (Neu) + 1.0 (Neg) = 4.0
      // Ideal distribution: 50% Pos, 25% Neu, 25% Neg
      expect(counts[AnswerCategory.positive]!, greaterThan(counts[AnswerCategory.neutral]!));
      expect(counts[AnswerCategory.positive]!, greaterThan(400)); // Should be around 500
    });

    test('Selection distribution biases correctly for Gloomy mood', () {
      final counts = <AnswerCategory, int>{
        AnswerCategory.positive: 0,
        AnswerCategory.neutral: 0,
        AnswerCategory.negative: 0,
      };

      const trials = 1000;
      for (int i = 0; i < trials; i++) {
        final selected = engine.selectAnswer(pool, OrbMood.gloomy);
        counts[selected.category] = (counts[selected.category] ?? 0) + 1;
      }

      print('Gloomy Counts: $counts');
      
      expect(counts[AnswerCategory.negative]!, greaterThan(counts[AnswerCategory.positive]!));
      expect(counts[AnswerCategory.negative]!, greaterThan(400));
    });
  });
}
