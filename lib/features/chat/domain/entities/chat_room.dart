import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room.freezed.dart';
part 'chat_room.g.dart';

/// Domain entity representing a chat conversation.
@freezed
abstract class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    required String id,
    required String clientId,
    required String ownerId,
    String? ownerName,
    String? ownerAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    @Default(0) int unreadCount,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
}
