import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/providers/app_providers.dart';


/// Provider for SyncService.
final syncServiceProvider = Provider<SyncService>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  return SyncService(supabase, db);
});

/// Handles syncing data from Supabase down to Drift (Local Cache).
class SyncService {
  SyncService(this._supabase, this._db);

  final SupabaseService _supabase;
  final AppDatabase _db;

  /// Sync all dashboard data for the given [clientId].
  /// 
  /// In this sprint, we simulate pulling from Supabase and inserting
  /// into Drift to demonstrate the offline-first architecture.
  Future<void> syncDashboardData(String clientId) async {
    try {
      AppLogger.info('Starting sync for client: $clientId');
      
      // 1. Sync Profile
      // Normally we would do: await _supabase.client.from('profiles').select().eq('id', clientId);
      // For this sprint, we mock the API response and upsert to Drift.
      final user = _supabase.client.auth.currentUser;
      final profile = ClientProfile(
        id: clientId,
        name: 'Client ArLABS',
        email: user?.email ?? '',
        phone: user?.phone ?? '+6281234567890',
        status: 'approved', // Dummy status for synced profile
        updatedAt: DateTime.now(),
      );
      await _db.into(_db.clientProfiles).insertOnConflictUpdate(profile);

      // 2. Sync Financial Summary
      final summary = FinancialSummary(
        clientId: clientId,
        totalReceivable: 5000000.0,
        outstanding: 2500000.0,
        paid: 2500000.0,
        nextDueAmount: 500000.0,
        nextDueDate: DateTime.now().add(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      );
      await _db.into(_db.financialSummaries).insertOnConflictUpdate(summary);

      // 3. Sync Recent Transactions
      final txn1 = RecentTransaction(
        id: 'txn_1',
        clientId: clientId,
        title: 'Pembayaran Cicilan 1',
        amount: 500000.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: 'payment',
        status: 'paid',
      );
      final txn2 = RecentTransaction(
        id: 'txn_2',
        clientId: clientId,
        title: 'Tagihan Cicilan 2',
        amount: 500000.0,
        date: DateTime.now().add(const Duration(days: 3)),
        type: 'reminder',
        status: 'pending',
      );
      
      await _db.into(_db.recentTransactions).insertOnConflictUpdate(txn1);
      await _db.into(_db.recentTransactions).insertOnConflictUpdate(txn2);

      AppLogger.info('Sync completed successfully');
    } catch (e) {
      AppLogger.error('Sync failed', error: e);
      // Depending on requirements, we might want to throw here, 
      // but usually sync fails silently in the background.
    }
  }
}
