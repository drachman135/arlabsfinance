import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/app_providers.dart';
import '../domain/repositories/chat_repository.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../domain/entities/chat_message.dart';

final chatSyncServiceProvider = Provider<ChatSyncService>((ref) {
  final supabase = ref.watch(supabaseServiceProvider).client;
  final db = ref.watch(appDatabaseProvider);
  final repo = ref.watch(chatRepositoryProvider);
  
  return ChatSyncService(supabase, db, repo);
});

class ChatSyncService {
  ChatSyncService(this._supabase, this._db, this._repo);

  final SupabaseClient _supabase;
  final AppDatabase _db;
  final ChatRepository _repo;
  RealtimeChannel? _channel;

  /// Starts listening to real-time updates for a specific room or all user's rooms.
  Future<void> startListening(String clientId) async {
    // Sync any pending messages in outbox first
    await _repo.syncOutbox();

    _channel = _supabase.channel('public:messages:receiver_id=eq.$clientId');
    
    _channel?.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'receiver_id',
        value: clientId,
      ),
      callback: (payload) async {
        final newRecord = payload.newRecord;
        if (newRecord.isNotEmpty) {
          // Process incoming message
          await _processIncomingMessage(newRecord);
        }
      },
    ).subscribe();
  }
  
  Future<void> _processIncomingMessage(Map<String, dynamic> record) async {
    final statusStr = record['status'] as String? ?? 'delivered';
    MessageStatus status;
    switch (statusStr) {
      case 'sent': status = MessageStatus.sent; break;
      case 'read': status = MessageStatus.read; break;
      case 'failed': status = MessageStatus.failed; break;
      case 'delivered':
      default:
        status = MessageStatus.delivered;
    }

    final message = ChatMessage(
      id: record['id'] as String,
      roomId: record['room_id'] as String,
      senderId: record['sender_id'] as String,
      receiverId: record['receiver_id'] as String,
      content: record['content'] as String,
      createdAt: DateTime.parse(record['created_at'] as String).toLocal(),
      status: status,
    );

    // Save to local drift database
    await _db.into(_db.chatMessages).insert(
      ChatMessagesCompanion.insert(
        id: message.id,
        roomId: message.roomId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        createdAt: message.createdAt,
        status: drift.Value(message.status.name),
      ),
      mode: drift.InsertMode.insertOrReplace,
    );
  }

  void stopListening() {
    _channel?.unsubscribe();
    _channel = null;
  }
}
