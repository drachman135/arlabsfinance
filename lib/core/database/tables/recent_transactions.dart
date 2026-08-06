import 'package:drift/drift.dart';

/// Recent Transactions table for local cache (Dashboard preview).
class RecentTransactions extends Table {
  TextColumn get id => text()(); // Transaction ID
  TextColumn get clientId => text()(); // Belongs to
  TextColumn get title => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  
  /// Type of transaction: 'debt', 'payment', 'reminder'
  TextColumn get type => text()(); 
  
  /// Status: 'pending', 'paid', 'overdue'
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}
