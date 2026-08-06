import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../constants/app_constants.dart';

import 'tables/client_profiles.dart';
import 'tables/financial_summaries.dart';
import 'tables/recent_transactions.dart';
import 'tables/chat_rooms.dart';
import 'tables/chat_messages.dart';

part 'app_database.g.dart';

/// Drift database for ArLABS Finance Client.
///
/// Cross-platform: uses SQLite on Android, WASM/IndexedDB on Web.
@DriftDatabase(tables: [
  ClientProfiles,
  FinancialSummaries,
  RecentTransactions,
  ChatRooms,
  ChatMessages,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  /// Opens a cross-platform database connection.
  /// drift_flutter handles native vs web automatically.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: AppConstants.databaseName,
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: null,
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            // Log missing features
          }
        },
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(chatRooms);
          await m.createTable(chatMessages);
        }
      },
    );
  }
}
