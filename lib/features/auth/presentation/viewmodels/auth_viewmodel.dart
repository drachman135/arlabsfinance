import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository_impl.dart';

/// StreamProvider exposing the Supabase AuthState.
/// Used by the GoRouter redirect to guard routes.
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.onAuthStateChange;
});

/// Exposes the current authenticated User (if any).
final authUserProvider = Provider<User?>((ref) {
  // We use currentSession instead of relying solely on the stream value
  // to ensure immediate availability if the session is already cached.
  final session = ref.watch(authRepositoryProvider).currentSession;
  return session?.user;
});

/// Determines if the user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authUserProvider) != null;
});

/// ViewModel managing login and logout actions.
class AuthViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  /// Perform login with email and password.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Mock dummy login bypass
      if (email == 'dev@test.com') {
        // We can't easily mock Supabase Session globally without a custom provider.
        // For simple UI testing, we will just proceed, but the router requires an actual Session.
        // Therefore, it's actually better if the dev creates a real dummy user in Supabase.
        // I will throw an exception to guide them, or attempt to sign up if it doesn't exist.
        final repository = ref.read(authRepositoryProvider);
        try {
          await repository.loginWithEmail(email, password);
        } catch (e) {
          try {
            await repository.registerWithEmail(email, password, 'Developer Klien');
            await repository.loginWithEmail(email, password);
          } catch (_) {
            throw Exception('Gagal membuat akun dummy. Pastikan internet aktif.');
          }
        }
        return;
      }
      
      final repository = ref.read(authRepositoryProvider);
      await repository.loginWithEmail(email, password);
    });
  }

  /// Perform registration with email, password, and name.
  Future<void> register(String email, String password, String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.registerWithEmail(email, password, name);
    });
  }

  /// Perform logout.
  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
    });
  }
}

/// Provider for the AuthViewModel.
final authViewModelProvider =
    AsyncNotifierProvider.autoDispose<AuthViewModel, void>(AuthViewModel.new);
