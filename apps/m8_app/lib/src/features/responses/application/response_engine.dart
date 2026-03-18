import 'dart:math' as math;
import '../domain/answer.dart';
import '../domain/orb_mood.dart';

/// The core mystical logic that selects the next answer.
class ResponseEngine {
  final math.Random _random = math.Random();

  /// Picks an answer using the Cumulative Weight Sum selection algorithm.
  /// Weights are influenced by current [OrbMood].
  Answer selectAnswer(List<Answer> pool, OrbMood mood) {
    if (pool.isEmpty) {
      throw Exception("Selection pool is empty!");
    }

    // 1. Calculate weighted sums
    final List<double> cumulativeWeights = [];
    double totalWeight = 0;

    for (final answer in pool) {
      final multiplier = mood.getWeightMultiplier(answer.category);
      final actualWeight = answer.baseWeight * multiplier;
      totalWeight += actualWeight;
      cumulativeWeights.add(totalWeight);
    }

    // 2. Linear search selection
    final target = _random.nextDouble() * totalWeight;
    for (int i = 0; i < cumulativeWeights.length; i++) {
       if (target < cumulativeWeights[i]) {
         return pool[i];
       }
    }

    return pool.last;
  }
}
