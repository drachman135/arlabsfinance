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
      final user = _supabase.client.auth.currentUser;
      
      // Fetch from Supabase
      final profileResponse = await _supabase.client
          .from('client_profiles')
          .select()
          .eq('id', clientId)
          .maybeSingle();
          
      String clientName = '';
      String clientStatus = 'approved';
      if (profileResponse != null) {
        if (profileResponse['name'] != null) clientName = profileResponse['name'] as String;
        if (profileResponse['status'] != null) clientStatus = profileResponse['status'] as String;
      }

      final profile = ClientProfile(
        id: clientId,
        name: clientName,
        email: user?.email ?? '',
        phone: user?.phone ?? '+6281234567890',
        status: clientStatus,
        updatedAt: DateTime.now(),
      );
      await _db.into(_db.clientProfiles).insertOnConflictUpdate(profile);

      // 2. Sync Financial Summary
      final summaryResponse = await _supabase.client
          .from('financial_summaries')
          .select()
          .eq('client_id', clientId)
          .maybeSingle();

      if (summaryResponse != null) {
        final summary = FinancialSummary(
          clientId: clientId,
          totalReceivable: (summaryResponse['total_receivable'] as num?)?.toDouble() ?? 0.0,
          outstanding: (summaryResponse['outstanding'] as num?)?.toDouble() ?? 0.0,
          paid: (summaryResponse['paid'] as num?)?.toDouble() ?? 0.0,
          nextDueAmount: (summaryResponse['next_due_amount'] as num?)?.toDouble() ?? 0.0,
          nextDueDate: summaryResponse['next_due_date'] != null 
              ? DateTime.parse(summaryResponse['next_due_date'] as String)
              : null,
          updatedAt: DateTime.now(),
        );
        await _db.into(_db.financialSummaries).insertOnConflictUpdate(summary);
      }

      // 3. Sync Recent Transactions
      final transactionsResponse = await _supabase.client
          .from('recent_transactions')
          .select()
          .eq('client_id', clientId)
          .order('date', ascending: false);

      if (transactionsResponse != null && (transactionsResponse as List).isNotEmpty) {
        for (final txnData in transactionsResponse) {
          final txn = RecentTransaction(
            id: txnData['id'] as String,
            clientId: clientId,
            title: txnData['title'] as String,
            amount: (txnData['amount'] as num?)?.toDouble() ?? 0.0,
            date: DateTime.parse(txnData['date'] as String),
            type: txnData['type'] as String,
            status: txnData['status'] as String,
          );
          await _db.into(_db.recentTransactions).insertOnConflictUpdate(txn);
        }
      }
      
      // 4. Sync Chat Rooms
      final roomsResponse = await _supabase.client
          .from('chat_rooms')
          .select()
          .eq('client_id', clientId);

      if (roomsResponse != null && (roomsResponse as List).isNotEmpty) {
        for (final roomData in roomsResponse) {
          await _db.into(_db.chatRooms).insertOnConflictUpdate(
            ChatRoomTableData(
              id: roomData['id'] as String,
              clientId: clientId,
              ownerId: roomData['owner_id'] as String,
              ownerName: roomData['owner_name'] as String?,
              ownerAvatar: roomData['owner_avatar'] as String?,
              lastMessage: roomData['last_message'] as String?,
              lastMessageTime: roomData['last_message_time'] != null 
                  ? DateTime.parse(roomData['last_message_time'] as String)
                  : null,
              unreadCount: (roomData['unread_count'] as num?)?.toInt() ?? 0,
            )
          );
        }
      }

      AppLogger.info('Sync completed successfully');
    } catch (e) {
      AppLogger.error('Sync failed', error: e);
      // Depending on requirements, we might want to throw here, 
      // but usually sync fails silently in the background.
    }
  }
}
