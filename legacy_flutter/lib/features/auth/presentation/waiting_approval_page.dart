import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/providers/app_providers.dart';
import 'viewmodels/auth_viewmodel.dart';

class WaitingApprovalPage extends ConsumerStatefulWidget {
  const WaitingApprovalPage({super.key});

  @override
  ConsumerState<WaitingApprovalPage> createState() => _WaitingApprovalPageState();
}

class _WaitingApprovalPageState extends ConsumerState<WaitingApprovalPage> {
  RealtimeChannel? _profileChannel;

  @override
  void initState() {
    super.initState();
    _listenToApprovalStatus();
  }

  void _listenToApprovalStatus() {
    final supabase = ref.read(supabaseServiceProvider).client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    _profileChannel = supabase.channel('public:client_profiles:id=eq.${user.id}');
    _profileChannel?.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'client_profiles',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: user.id,
      ),
      callback: (payload) {
        final newRecord = payload.newRecord;
        if (newRecord['status'] == 'approved') {
          if (mounted) {
            context.go(RoutePaths.dashboard);
          }
        }
      },
    ).subscribe();
  }

  @override
  void dispose() {
    _profileChannel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_empty,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppDimensions.spacing24),
              Text(
                'Menunggu Persetujuan',
                style: AppTextStyles.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                'Akun Anda sedang ditinjau oleh Admin/Owner. Harap bersabar, Anda akan otomatis masuk setelah akun disetujui.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing40),
              const CircularProgressIndicator(),
              const SizedBox(height: AppDimensions.spacing40),
              TextButton(
                onPressed: () {
                  ref.read(authViewModelProvider.notifier).logout();
                },
                child: Text(
                  'Batalkan & Keluar',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
