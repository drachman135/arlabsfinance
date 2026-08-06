import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository interface for authentication.
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<AuthResponse> loginWithEmail(String email, String password);
  
  /// Sign out the current user.
  Future<void> logout();

  /// Get the current session if any.
  Session? get currentSession;

  /// Stream of authentication state changes.
  Stream<AuthState> get onAuthStateChange;
}
