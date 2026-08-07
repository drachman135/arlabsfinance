import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'viewmodels/auth_viewmodel.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final identifier = _identifierController.text.trim();
      final password = _passwordController.text;

      final isEmail = identifier.contains('@');
      
      if (!isEmail) {
        AppSnackbar.warning(
          context,
          'Pendaftaran menggunakan nomor telepon belum diaktifkan. Silakan gunakan email.',
        );
        return;
      }

      ref.read(authViewModelProvider.notifier).register(identifier, password, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      authViewModelProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            AppSnackbar.success(context, 'Pendaftaran berhasil. Silakan tunggu persetujuan.');
            context.go(RoutePaths.waitingApproval);
          },
          error: (error, stackTrace) {
            AppLogger.error('Register error', error: error, stackTrace: stackTrace);
            AppSnackbar.error(context, error.toString());
          },
        );
      },
    );

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Akun Baru', style: AppTextStyles.headingSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.surfaceGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Buat Akun Anda',
                        style: AppTextStyles.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        'Lengkapi data di bawah ini untuk bergabung',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacing40),

                      AppTextField(
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap Anda',
                        prefixIcon: Icons.badge_outlined,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Harap masukkan nama Anda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing16),

                      AppTextField(
                        controller: _identifierController,
                        label: 'Email',
                        hint: 'Masukkan email Anda',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Harap masukkan email Anda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing16),

                      AppTextField(
                        controller: _passwordController,
                        label: 'Kata Sandi',
                        hint: 'Masukkan kata sandi',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_isPasswordVisible,
                        enabled: !isLoading,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harap masukkan kata sandi Anda';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing32),

                      AppButton(
                        label: 'Daftar',
                        onPressed: _onRegister,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
