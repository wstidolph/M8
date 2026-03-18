import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/answer.dart';
import 'providers/local_answer_provider.dart';
import 'providers/supabase_answer_provider.dart';

/// Facade that orchestrates sync and provide persistent caching.
class AnswerRepository {
  final LocalAnswerProvider _local = LocalAnswerProvider();
  final SupabaseAnswerProvider _remote = SupabaseAnswerProvider();
  final _storage = const FlutterSecureStorage();
  
  static const _cacheKey = 'm8_answer_cache';
  List<Answer> _cachedAnswers = [];

  /// Returns the current answer pool. Falls back to classic if no sync yet.
  Future<List<Answer>> getActivePool() async {
    if (_cachedAnswers.isEmpty) {
      // 1. Load from Persistent Cache
      final cachedJson = await _storage.read(key: _cacheKey);
      if (cachedJson != null) {
        try {
          final List<dynamic> list = json.decode(cachedJson);
          _cachedAnswers = list.map((j) => Answer.fromJson(j)).toList();
        } catch (_) {
          // Clear if malformed
          await _storage.delete(key: _cacheKey);
        }
      }
      
      // 2. Load from Local Classic if no cache
      if (_cachedAnswers.isEmpty) {
        _cachedAnswers = await _local.getAnswers();
      }
    }

    // Prioritize "Special Event" answers if present in the pool (US2)
    final eventPool = _cachedAnswers.where((a) => a.isEvent).toList();
    return eventPool.isNotEmpty ? eventPool : _cachedAnswers;
  }

  /// Attempts to sync with remote source and update both memory and disk cache.
  Future<void> syncRemote() async {
    final remoteAnswers = await _remote.getAnswers();
    if (remoteAnswers.isNotEmpty) {
      _cachedAnswers = remoteAnswers;
      
      // Persist for offline-first resilience
      final String jsonStr = json.encode(remoteAnswers.map((a) => a.toJson()).toList());
      await _storage.write(key: _cacheKey, value: jsonStr);
    }
  }
}
