import '../../../../core/database/app_database.dart';

/// Repository interface for Dashboard data (Local Cache).
abstract class DashboardRepository {
  /// Stream the client profile.
  Stream<ClientProfile?> watchClientProfile(String clientId);

  /// Stream the financial summary.
  Stream<FinancialSummary?> watchFinancialSummary(String clientId);

  /// Stream recent transactions.
  Stream<List<RecentTransaction>> watchRecentTransactions(String clientId);
}
