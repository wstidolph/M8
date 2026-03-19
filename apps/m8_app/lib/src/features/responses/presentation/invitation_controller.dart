import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  InvitationController() : super(const InvitationProgress());

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
