import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/router/route_names.dart';
import '../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../chat/presentation/viewmodels/chat_list_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';

/// Client Dashboard Page.
///
/// Displays financial summary, sync status, and quick menu.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final profile = state.profile;
    final summary = state.summary;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${profile?.name ?? 'Klien'}',
                  style: AppTextStyles.headingSmall,
                ),
                Row(
                  children: [
                    Icon(
                      state.isSyncing
                          ? Icons.sync
                          : Icons.check_circle_outline,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      state.isSyncing ? 'Sedang Sinkronisasi...' : 'Baru saja diperbarui',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          children: [
            // Financial Summary Card
            AppCard(
              backgroundColor: AppColors.surfaceLight,
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sisa Piutang (Outstanding)',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${summary?.outstanding.toStringAsFixed(0) ?? '0'}',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem(
                        'Total Piutang',
                        'Rp ${summary?.totalReceivable.toStringAsFixed(0) ?? '0'}',
                      ),
                      _buildSummaryItem(
                        'Sudah Dibayar',
                        'Rp ${summary?.paid.toStringAsFixed(0) ?? '0'}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),

            // Quick Menu
            Text('Menu Cepat', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppDimensions.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuIcon(Icons.receipt_long, 'Piutang', onTap: () {}),
                _buildMenuIcon(Icons.payment, 'Pembayaran', onTap: () {}),
                _buildMenuIcon(Icons.notifications_active, 'Pengingat', onTap: () {}),
                Consumer(
                  builder: (context, ref, _) {
                    final chatList = ref.watch(chatListStreamProvider).value ?? [];
                    final totalUnread = chatList.fold<int>(0, (sum, room) => sum + room.unreadCount);
                    
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildMenuIcon(Icons.chat, 'Pesan', onTap: () => context.push(RoutePaths.chatList)),
                        if (totalUnread > 0)
                          Positioned(
                            top: -4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$totalUnread',
                                style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 8),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing32),

            // Next Due & Recent Transactions
            Text('Transaksi Terakhir', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppDimensions.spacing16),
            ...state.transactions.map((txn) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
                child: AppCard(
                  backgroundColor: AppColors.surface,
                  borderColor: AppColors.border,
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: txn.type == 'payment'
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          txn.type == 'payment'
                              ? Icons.check_circle
                              : Icons.warning_amber,
                          color: txn.type == 'payment'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(txn.title, style: AppTextStyles.headingSmall),
                            Text(
                              txn.status.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Rp ${txn.amount.toStringAsFixed(0)}',
                        style: AppTextStyles.headingSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headingSmall,
        ),
      ],
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelMedium,
          ),
        ],
      ),
    );
  }
}
