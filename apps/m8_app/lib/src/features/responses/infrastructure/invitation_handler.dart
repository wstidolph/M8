import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'answer_repository.dart';

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

  Future<void> _acceptInvitation(String setId) async {
    final supabase = Supabase.instance.client;
    
    try {
      // 1. Fetch the custom Answer Set (Feature 007)
      final response = await supabase
          .from('answer_sets')
          .select('*, answers(*)')
          .eq('set_id', setId)
          .single();

      final answers = (response['answers'] as List)
            .map((a) => a['response_text'] as String)
            .toList();

        final label = response['label'] as String;

        // 2. Cache it locally via AnswerRepository (Principle III)
        await _ref.read(answerRepositoryProvider).setCustomAnswers(answers, label);
        
        debugPrint('Successfully accepted M8 invitation: $label');
    } catch (e) {
      debugPrint('Failed to accept M8 invitation: $e');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
