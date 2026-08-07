import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Provider for DashboardRepository.
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DashboardRepositoryImpl(db);
});

/// Implementation of DashboardRepository reading from Drift Local Cache.
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<ClientProfile?> watchClientProfile(String clientId) {
    return (_db.select(_db.clientProfiles)..where((t) => t.id.equals(clientId)))
        .watchSingleOrNull();
  }

  @override
  Stream<FinancialSummary?> watchFinancialSummary(String clientId) {
    return (_db.select(_db.financialSummaries)
          ..where((t) => t.clientId.equals(clientId)))
        .watchSingleOrNull();
  }

  @override
  Stream<List<RecentTransaction>> watchRecentTransactions(String clientId) {
    return (_db.select(_db.recentTransactions)
          ..where((t) => t.clientId.equals(clientId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ]))
        .watch();
  }
}
