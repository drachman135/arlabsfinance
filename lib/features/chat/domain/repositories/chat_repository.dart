import '../entities/chat_message.dart';
import '../entities/chat_room.dart';

/// Repository interface for Chat operations.
/// Acts as an adapter between the local cache (Drift) and remote (Supabase).
abstract class ChatRepository {
  /// Watch the list of chat rooms for the current client.
  Stream<List<ChatRoom>> watchChatRooms(String clientId);

  /// Watch messages for a specific room.
  Stream<List<ChatMessage>> watchMessages(String roomId);

  /// Send a text message to a room.
  /// If offline, this will store the message in the Outbox queue.
  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String receiverId,
    required String content,
  });

  /// Mark messages as read in a room.
  Future<void> markAsRead(String roomId, String userId);

  /// Push all pending messages from Outbox to Supabase.
  Future<void> syncOutbox();
}
