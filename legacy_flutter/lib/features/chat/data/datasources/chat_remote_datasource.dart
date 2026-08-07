import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/chat_message.dart';

/// Remote data source for Chat Engine (Supabase).
class ChatRemoteDataSource {
  ChatRemoteDataSource(this._supabase);

  final SupabaseClient _supabase;

  /// Send a message to Supabase.
  Future<void> sendMessage(ChatMessage message) async {
    await _supabase.from('messages').insert({
      'id': message.id,
      'room_id': message.roomId,
      'sender_id': message.senderId,
      'receiver_id': message.receiverId,
      'content': message.content,
      'status': 'sent', // Initially sent when reaches server
      'created_at': message.createdAt.toIso8601String(),
    });
  }

  /// Mark messages as read in Supabase.
  Future<void> markAsRead(String roomId, String userId) async {
    await _supabase
        .from('messages')
        .update({'status': 'read'})
        .eq('room_id', roomId)
        .eq('receiver_id', userId)
        .neq('status', 'read');
  }
}
