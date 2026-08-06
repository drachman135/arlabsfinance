import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_room.dart';

/// Local data source for Chat Engine (Drift).
class ChatLocalDataSource {
  ChatLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<ChatRoom>> watchChatRooms(String clientId) {
    final query = _db.select(_db.chatRooms)..where((t) => t.clientId.equals(clientId));
    return query.watch().map((rows) {
      return rows.map((r) => ChatRoom(
        id: r.id,
        clientId: r.clientId,
        ownerId: r.ownerId,
        ownerName: r.ownerName,
        ownerAvatar: r.ownerAvatar,
        lastMessage: r.lastMessage,
        lastMessageTime: r.lastMessageTime,
        unreadCount: r.unreadCount,
      )).toList();
    });
  }

  Stream<List<ChatMessage>> watchMessages(String roomId) {
    final query = _db.select(_db.chatMessages)
      ..where((t) => t.roomId.equals(roomId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    return query.watch().map((rows) {
      return rows.map((r) => ChatMessage(
        id: r.id,
        roomId: r.roomId,
        senderId: r.senderId,
        receiverId: r.receiverId,
        content: r.content,
        createdAt: r.createdAt,
        status: _mapStatus(r.status),
      )).toList();
    });
  }

  Future<void> saveMessage(ChatMessage message) async {
    await _db.into(_db.chatMessages).insert(
      ChatMessagesCompanion.insert(
        id: message.id,
        roomId: message.roomId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        createdAt: message.createdAt,
        status: Value(message.status.name),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<ChatMessage>> getPendingMessages() async {
    final query = _db.select(_db.chatMessages)..where((t) => t.status.equals('pending'));
    final rows = await query.get();
    return rows.map((r) => ChatMessage(
      id: r.id,
      roomId: r.roomId,
      senderId: r.senderId,
      receiverId: r.receiverId,
      content: r.content,
      createdAt: r.createdAt,
      status: MessageStatus.pending,
    )).toList();
  }

  Future<void> updateMessageStatus(String id, String status) async {
    await (_db.update(_db.chatMessages)..where((t) => t.id.equals(id))).write(
      ChatMessagesCompanion(status: Value(status)),
    );
  }

  Future<void> markRoomAsRead(String roomId, String userId) async {
    await (_db.update(_db.chatMessages)
      ..where((t) => t.roomId.equals(roomId))
      ..where((t) => t.receiverId.equals(userId))
      ..where((t) => t.status.isNotValue('read'))
    ).write(
      const ChatMessagesCompanion(status: Value('read')),
    );
  }

  MessageStatus _mapStatus(String status) {
    switch (status) {
      case 'sent': return MessageStatus.sent;
      case 'delivered': return MessageStatus.delivered;
      case 'read': return MessageStatus.read;
      case 'failed': return MessageStatus.failed;
      case 'pending': 
      default:
        return MessageStatus.pending;
    }
  }
}
