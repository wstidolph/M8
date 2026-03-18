import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/answer.dart';
import '../../domain/answer_source.dart';

/// Loads the classic 20 responses from local assets.
class LocalAnswerProvider implements AnswerSource {
  @override
  String get sourceId => 'classic';

  @override
  Future<List<Answer>> getAnswers() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/classic_answers.json');
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.map((j) => Answer.fromJson({
        ...j as Map<String, dynamic>,
        'source': sourceId,
      })).toList();
    } catch (e) {
      // In a real app, log error or return empty
      return [];
    }
  }
}
