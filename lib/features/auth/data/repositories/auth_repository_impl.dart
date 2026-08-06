import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/error/app_exception.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthRepositoryImpl(supabaseService.client.auth);
});

/// Implementation of AuthRepository using Supabase.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authClient);

  final sb.GoTrueClient _authClient;

  @override
  sb.Session? get currentSession => _authClient.currentSession;

  @override
  Stream<sb.AuthState> get onAuthStateChange => _authClient.onAuthStateChange;

  @override
  Future<sb.AuthResponse> loginWithEmail(String email, String password) async {
    try {
      final response = await _authClient.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on sb.AuthException catch (e) {
      throw AuthException(
        message: e.message,
      );
    } catch (e) {
      throw const UnknownException(
        message: 'An unexpected error occurred during login',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authClient.signOut();
    } catch (e) {
      throw const UnknownException(
        message: 'Failed to sign out',
      );
    }
  }
}
