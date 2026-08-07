import 'package:drift/drift.dart';

/// Financial Summaries table for local cache.
class FinancialSummaries extends Table {
  TextColumn get clientId => text()(); // Supabase user ID
  RealColumn get totalReceivable => real().withDefault(const Constant(0.0))();
  RealColumn get outstanding => real().withDefault(const Constant(0.0))();
  RealColumn get paid => real().withDefault(const Constant(0.0))();
  RealColumn get nextDueAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get nextDueDate => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {clientId};
}
