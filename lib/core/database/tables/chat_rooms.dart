import 'package:drift/drift.dart';

/// Table definition for local chat rooms.
/// Matches the schema from the existing Chat Engine on Supabase.
@DataClassName('ChatRoomTableData')
class ChatRooms extends Table {
  TextColumn get id => text()(); // UUID from Supabase
  TextColumn get clientId => text()();
  TextColumn get ownerId => text()();
  TextColumn get ownerName => text().nullable()();
  TextColumn get ownerAvatar => text().nullable()();
  TextColumn get lastMessage => text().nullable()();
  DateTimeColumn get lastMessageTime => dateTime().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
