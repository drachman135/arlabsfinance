import 'package:drift/drift.dart';

/// Client Profiles table for local cache.
class ClientProfiles extends Table {
  TextColumn get id => text()(); // Supabase user ID
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
