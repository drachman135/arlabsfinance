import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../domain/entities/chat_message.dart';
import '../../application/chat_presence_service.dart';
import '../../data/repositories/chat_repository_impl.dart';

part 'chat_room_viewmodel.g.dart';

@riverpod
class ChatRoomViewModel extends _$ChatRoomViewModel {
  StreamSubscription<List<ChatMessage>>? _messagesSub;

  @override
  List<ChatMessage> build(String roomId) {
    final repo = ref.watch(chatRepositoryProvider);
    final user = ref.watch(authUserProvider);

    if (user != null) {
      _messagesSub = repo.watchMessages(roomId).listen((messages) {
        state = messages;
        
        // Mark as read when messages are received in an active room
        final unreadMessages = messages.where(
          (m) => m.receiverId == user.id && m.status != MessageStatus.read
        );
        if (unreadMessages.isNotEmpty) {
          repo.markAsRead(roomId, user.id);
        }
      });
      
      // Start presence & typing listener
      // In a real app, the ownerId should be fetched from ChatRoom
      // Here we assume it will be initialized from UI
    }

    ref.onDispose(() {
      _messagesSub?.cancel();
    });

    return [];
  }

  Future<void> sendMessage(String content, String ownerId) async {
    if (content.trim().isEmpty) return;

    final user = ref.read(authUserProvider);
    if (user == null) return;

    final repo = ref.read(chatRepositoryProvider);
    await repo.sendMessage(
      roomId: roomId,
      senderId: user.id,
      receiverId: ownerId,
      content: content.trim(),
    );
  }

  void setTyping(bool isTyping) {
    ref.read(chatPresenceServiceProvider).sendTypingEvent(roomId, isTyping);
  }
}
