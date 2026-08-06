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
      final repository = ref.read(authRepositoryProvider);
      await repository.loginWithEmail(email, password);
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
