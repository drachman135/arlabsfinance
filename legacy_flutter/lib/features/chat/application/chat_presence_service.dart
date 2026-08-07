import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/providers/app_providers.dart';

part 'chat_presence_service.g.dart';

@riverpod
class TypingState extends _$TypingState {
  @override
  bool build(String roomId) => false;
  void updateState(bool typing) => state = typing;
}

@riverpod
class PresenceState extends _$PresenceState {
  @override
  bool build(String userId) => false;
  void updateState(bool online) => state = online;
}

final chatPresenceServiceProvider = Provider<ChatPresenceService>((ref) {
  final supabase = ref.watch(supabaseServiceProvider).client;
  return ChatPresenceService(supabase, ref);
});

class ChatPresenceService {
  ChatPresenceService(this._supabase, this._ref);

  final SupabaseClient _supabase;
  final Ref _ref;
  RealtimeChannel? _presenceChannel;
  RealtimeChannel? _typingChannel;

  Future<void> joinPresence(String userId) async {
    _presenceChannel = _supabase.channel('online-users');
    
    _presenceChannel?.onPresenceSync((payload) {
      final state = _presenceChannel?.presenceState();
      if (state != null) {
        // Evaluate if the target user is in the presence state
        // This is a simplified check.
        // Simplified online check
        final isOnline = state.isNotEmpty;
        _ref.read(presenceStateProvider(userId).notifier).updateState(isOnline);
      }
    }).subscribe((status, [error]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        await _presenceChannel?.track({'user_id': _supabase.auth.currentUser?.id});
      }
    });
  }

  Future<void> listenTyping(String roomId, String ownerId) async {
    _typingChannel = _supabase.channel('typing:$roomId');
    
    _typingChannel?.onBroadcast(
      event: 'typing',
      callback: (payload) {
        if (payload['user_id'] == ownerId) {
          final isTyping = payload['is_typing'] as bool? ?? false;
          _ref.read(typingStateProvider(roomId).notifier).updateState(isTyping);
        }
      },
    ).subscribe();
  }

  Future<void> sendTypingEvent(String roomId, bool isTyping) async {
    await _typingChannel?.sendBroadcastMessage(
      event: 'typing',
      payload: {
        'user_id': _supabase.auth.currentUser?.id,
        'is_typing': isTyping,
      },
    );
  }

  void dispose() {
    _presenceChannel?.unsubscribe();
    _typingChannel?.unsubscribe();
  }
}
