import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../application/sync_service.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

part 'dashboard_viewmodel.g.dart';

/// State representing all data on the Dashboard.
class DashboardState {
  DashboardState({
    this.profile,
    this.summary,
    this.transactions = const [],
    this.isSyncing = false,
  });

  final ClientProfile? profile;
  final FinancialSummary? summary;
  final List<RecentTransaction> transactions;
  final bool isSyncing;

  DashboardState copyWith({
    ClientProfile? profile,
    FinancialSummary? summary,
    List<RecentTransaction>? transactions,
    bool? isSyncing,
  }) {
    return DashboardState(
      profile: profile ?? this.profile,
      summary: summary ?? this.summary,
      transactions: transactions ?? this.transactions,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

/// ViewModel for Dashboard.
///
/// Listens to local Drift cache and triggers background syncs.
@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  DashboardState build() {
    Future.microtask(() {
      _initStreams();
      final user = ref.read(authUserProvider);
      if (user != null) {
        _triggerSync(user.id);
      }
    });
    
    return DashboardState();
  }

  void _initStreams() {
    final user = ref.read(authUserProvider);
    if (user == null) return;
    
    final repo = ref.read(dashboardRepositoryProvider);
    
    // Listen to profile
    final profileSub = repo.watchClientProfile(user.id).listen((profile) {
      state = state.copyWith(profile: profile);
    });
    ref.onDispose(profileSub.cancel);
    
    // Listen to summary
    final summarySub = repo.watchFinancialSummary(user.id).listen((summary) {
      state = state.copyWith(summary: summary);
    });
    ref.onDispose(summarySub.cancel);
    
    // Listen to transactions
    final txnsSub = repo.watchRecentTransactions(user.id).listen((txns) {
      state = state.copyWith(transactions: txns);
    });
    ref.onDispose(txnsSub.cancel);
  }

  Future<void> _triggerSync(String clientId) async {
    state = state.copyWith(isSyncing: true);
    await ref.read(syncServiceProvider).syncDashboardData(clientId);
    state = state.copyWith(isSyncing: false);
  }
  
  /// Pull to refresh action.
  Future<void> refresh() async {
    final user = ref.read(authUserProvider);
    if (user != null) {
      await _triggerSync(user.id);
    }
  }
}
