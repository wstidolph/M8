import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../presentation/invitation_controller.dart';

final invitationHandlerProvider = Provider((ref) => InvitationHandler(ref));

class InvitationHandler {
  final Ref _ref;
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  InvitationHandler(this._ref);

  void init() {
    // 1. Handle initial link (if app was opened via link)
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleUri(uri);
    });

    // 2. Handle subsequent links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    debugPrint('M8 Invitation URI: $uri');
    if (uri.scheme == 'm8ball' && uri.path == '/accept') {
      final id = uri.queryParameters['id'];
      if (id != null) {
        _acceptInvitation(id);
      }
    }
  }

  Future<void> _acceptInvitation(String giftOrSetId) async {
    final supabase = Supabase.instance.client;
    
    try {
      // 1. Fetch the Gift Entry to check status (Feature 009)
      final giftResponse = await supabase
          .from('gifts')
          .select('*, answer_sets(*, answers(*))')
          .filter('gift_id', 'eq', giftOrSetId)
          .maybeSingle();

      if (giftResponse == null) {
        debugPrint('Gift not found: $giftOrSetId');
        return;
      }

      final status = giftResponse['status'] as String;
      
      if (status == 'PENDING_REVIEW') {
        _ref.read(invitationControllerProvider.notifier).setGated(giftId: giftOrSetId);
        return;
      }

      if (status != 'ACTIVE') {
        debugPrint('M8 Invitation is no longer active ($status).');
        return;
      }

      final set = giftResponse['answer_sets'];
      final List<String> answers = (set['answers'] as List)
            .map((a) => a['response_text'] as String)
            .toList();

      final label = set['label'] as String;

      // 2. Set Pending (Feature 010) - User must manually accept via shake
      _ref.read(invitationControllerProvider.notifier).setPending(
        giftId: giftOrSetId,
        label: label,
        answers: answers,
      );
      
      debugPrint('M8 Invitation loaded and pending acceptance: $label');
    } catch (e) {
      debugPrint('Failed to accept M8 invitation: $e');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
