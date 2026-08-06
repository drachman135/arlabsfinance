import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Riverpod provider for the Drift database instance.
///
/// Provides a singleton database instance across the app.
/// Disposing closes the database connection properly.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  ref.onDispose(() {
    db.close();
  });

  return db;
});
