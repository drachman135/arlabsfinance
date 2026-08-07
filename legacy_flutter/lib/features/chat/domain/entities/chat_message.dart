import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Status of a chat message.
enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
  failed,
}

/// Domain entity representing a single chat message.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String roomId,
    required String senderId,
    required String receiverId,
    required String content,
    required DateTime createdAt,
    @Default(MessageStatus.sent) MessageStatus status,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
