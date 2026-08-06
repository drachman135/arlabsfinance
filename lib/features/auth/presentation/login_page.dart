import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import 'viewmodels/auth_viewmodel.dart';

/// ArLABS Login Page.
///
/// Supports email/password login. Phone login abstraction is prepared
/// but depends on backend activation.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final identifier = _identifierController.text.trim();
      final password = _passwordController.text;

      // Note: If phone login is activated, we would check if identifier
      // is a phone number and call a different Supabase method.
      // For now, we assume email login as per current setup.
      final isEmail = identifier.contains('@');
      
      if (!isEmail) {
        AppSnackbar.warning(
          context,
          'Login menggunakan nomor telepon belum diaktifkan. Silakan gunakan email.',
        );
        return;
      }

      ref.read(authViewModelProvider.notifier).login(identifier, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for error states
    ref.listen<AsyncValue<void>>(
      authViewModelProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            AppLogger.error('Login error', error: error, stackTrace: stackTrace);
            AppSnackbar.error(context, error.toString());
          },
        );
      },
    );

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing32),

                    // Title
                    Text(
                      'Selamat Datang',
                      style: AppTextStyles.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    Text(
                      'Masuk ke akun ArLABS Finance Anda',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacing40),

                    // Identifier (Email/Phone)
                    AppTextField(
                      controller: _identifierController,
                      label: 'Email atau Nomor Telepon',
                      hint: 'Masukkan email atau nomor telepon Anda',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Harap masukkan email atau nomor telepon Anda';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacing16),

                    // Password
                    AppTextField(
                      controller: _passwordController,
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandi Anda',
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
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacing32),

                    // Login Button
                    AppButton(
                      label: 'Masuk',
                      onPressed: _onLogin,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: AppDimensions.spacing24),

                    // Register hint (As per requirements: Accounts created by owner)
                    Text(
                      'Belum punya akun?\nSilakan hubungi perwakilan ArLABS Anda.',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
