import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/answer.dart';
import 'providers/local_answer_provider.dart';
import 'providers/supabase_answer_provider.dart';

final answerRepositoryProvider = Provider((ref) => AnswerRepository());

/// Facade that orchestrates sync and provide persistent caching.
class AnswerRepository {
  final LocalAnswerProvider _local = LocalAnswerProvider();
  final SupabaseAnswerProvider _remote = SupabaseAnswerProvider();
  final _storage = const FlutterSecureStorage();
  
  static const _cacheKey = 'm8_answer_cache';
  static const _customKey = 'm8_custom_answer_set';
  List<Answer> _cachedAnswers = [];
  List<Answer> _customAnswers = [];
  String? _customLabel;

  /// Returns the current answer pool. Falls back to classic if no sync yet.
  Future<List<Answer>> getActivePool() async {
    // 1. Try Loading from Custom Set (Feature 007 - Invitations)
    if (_customAnswers.isEmpty) {
       final customJson = await _storage.read(key: _customKey);
       if (customJson != null) {
          final List<dynamic> list = json.decode(customJson);
          _customAnswers = list.map((j) => Answer.fromJson(j)).toList();
       }
    }

    if (_customAnswers.isNotEmpty) {
      return _customAnswers;
    }

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

  /// Persist a custom gifted set (Feature 007 Social).
  Future<void> setCustomAnswers(List<String> rawAnswers, String label) async {
    _customLabel = label;
    _customAnswers = rawAnswers.asMap().entries.map((e) {
      return Answer(
        text: e.value,
        category: AnswerCategory.positive, 
        isEvent: false,
        source: 'author-gift',
      );
    }).toList();

    final String jsonStr = json.encode(_customAnswers.map((a) => a.toJson()).toList());
    await _storage.write(key: _customKey, value: jsonStr);
    await _storage.write(key: '${_customKey}_label', value: label);
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

  /// Remove custom set and revert to globe pool.
  Future<void> clearCustomSet() async {
    _customAnswers = [];
    _customLabel = null;
    await _storage.delete(key: _customKey);
    await _storage.delete(key: '${_customKey}_label');
  }

  /// Get the current set label (classic or custom)
  Future<String> getLabel() async {
    if (_customLabel == null) {
      _customLabel = await _storage.read(key: '${_customKey}_label');
    }
    return _customLabel ?? 'M8 Classic';
  }
}
