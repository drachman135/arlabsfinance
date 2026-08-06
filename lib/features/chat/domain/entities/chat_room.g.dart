// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => _ChatRoom(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  ownerId: json['ownerId'] as String,
  ownerName: json['ownerName'] as String?,
  ownerAvatar: json['ownerAvatar'] as String?,
  lastMessage: json['lastMessage'] as String?,
  lastMessageTime: json['lastMessageTime'] == null
      ? null
      : DateTime.parse(json['lastMessageTime'] as String),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChatRoomToJson(_ChatRoom instance) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'ownerId': instance.ownerId,
  'ownerName': ?instance.ownerName,
  'ownerAvatar': ?instance.ownerAvatar,
  'lastMessage': ?instance.lastMessage,
  'lastMessageTime': ?instance.lastMessageTime?.toIso8601String(),
  'unreadCount': instance.unreadCount,
};
