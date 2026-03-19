import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../infrastructure/answer_repository.dart';

enum InvitationStatus { none, pending, gated, accepted, rejected }

class InvitationProgress {
  final InvitationStatus status;
  final String? giftId;
  final String? label;
  final List<String>? answers;

  const InvitationProgress({
    this.status = InvitationStatus.none,
    this.giftId,
    this.label,
    this.answers,
  });

  InvitationProgress copyWith({
    InvitationStatus? status,
    String? giftId,
    String? label,
    List<String>? answers,
  }) {
    return InvitationProgress(
      status: status ?? this.status,
      giftId: giftId ?? this.giftId,
      label: label ?? this.label,
      answers: answers ?? this.answers,
    );
  }
}

class InvitationController extends StateNotifier<InvitationProgress> {
  final _supabase = Supabase.instance.client;

  InvitationController() : super(const InvitationProgress()) {
    _initDeepLinks();
  }

  void _initDeepLinks() {
    if (kIsWeb) {
      // Direct URL check for browser simulation
      final uri = Uri.base;
      final giftId = uri.queryParameters['gift'];
      if (giftId != null) {
        fetchGift(giftId);
      }
    }
  }

  Future<void> fetchGift(String giftId) async {
    try {
      final res = await _supabase
          .from('gifts')
          .select('*, answer_sets(*, answers(*))')
          .eq('gift_id', giftId)
          .single();

      if (res != null) {
        final List<dynamic> rawAnswers = res['answer_sets']['answers'];
        final List<String> textAnswers = rawAnswers
            .map((a) => a['response_text'] as String)
            .toList();
        
        state = state.copyWith(
          status: InvitationStatus.pending,
          giftId: giftId,
          label: res['answer_sets']['label'],
          answers: textAnswers,
        );
      }
    } catch (e) {
      // Silent fail for demo stability
      print('Gift fetch failed: $e');
    }
  }

  void setPending({required String giftId, required String label, required List<String> answers}) {
    state = state.copyWith(
      status: InvitationStatus.pending,
      giftId: giftId,
      label: label,
      answers: answers,
    );
  }

  void setGated({required String giftId}) {
    state = state.copyWith(
      status: InvitationStatus.gated,
      giftId: giftId,
    );
  }

  void clear() {
    state = const InvitationProgress(status: InvitationStatus.none);
  }
}

final invitationControllerProvider = StateNotifierProvider<InvitationController, InvitationProgress>((ref) {
  return InvitationController();
});
