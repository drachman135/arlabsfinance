import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers/app_providers.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = ref.watch(supabaseServiceProvider).client;
  
  return ChatRepositoryImpl(
    ChatLocalDataSource(db),
    ChatRemoteDataSource(supabase),
  );
});

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._local, this._remote);

  final ChatLocalDataSource _local;
  final ChatRemoteDataSource _remote;

  @override
  Stream<List<ChatRoom>> watchChatRooms(String clientId) {
    return _local.watchChatRooms(clientId);
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String roomId) {
    return _local.watchMessages(roomId);
  }

  @override
  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final message = ChatMessage(
      id: const Uuid().v4(),
      roomId: roomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      createdAt: DateTime.now().toUtc(),
      status: MessageStatus.pending,
    );

    // Save locally first (offline-first approach)
    await _local.saveMessage(message);

    // Trigger sync process
    // In a real app, this might be handled by a background worker / Connectivity listener
    await syncOutbox();
  }

  @override
  Future<void> markAsRead(String roomId, String userId) async {
    await _local.markRoomAsRead(roomId, userId);
    
    try {
      await _remote.markAsRead(roomId, userId);
    } catch (e) {
      // Ignored: will sync next time
    }
  }

  @override
  Future<void> syncOutbox() async {
    final pendingMessages = await _local.getPendingMessages();
    
    for (final msg in pendingMessages) {
      try {
        await _remote.sendMessage(msg);
        await _local.updateMessageStatus(msg.id, 'sent');
      } catch (e) {
        // Leave as pending if failed due to network
      }
    }
  }
}
