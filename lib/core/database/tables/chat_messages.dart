import 'package:drift/drift.dart';

/// Table definition for local chat messages.
/// Includes offline queue support via status='pending'.
@DataClassName('ChatMessageTableData')
class ChatMessages extends Table {
  TextColumn get id => text()(); // UUID from Supabase (or local generated if pending)
  TextColumn get roomId => text()();
  TextColumn get senderId => text()();
  TextColumn get receiverId => text()();
  TextColumn get content => text()();
  
  // Status: pending, sent, delivered, read, failed
  TextColumn get status => text().withDefault(const Constant('sent'))();
  
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
