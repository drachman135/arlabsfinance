import 'package:supabase_flutter/supabase_flutter.dart';

import '../storage/secure_storage_service.dart';

/// Secure local storage implementation for Supabase Auth.
///
/// Ensures Supabase session and tokens are saved securely using
/// flutter_secure_storage instead of the default shared_preferences.
class SecureLocalStorage extends LocalStorage {
  final SecureStorageService _storage = SecureStorageService.instance;

  @override
  Future<void> initialize() async {
    // Initialization handled by SecureStorageService in bootstrap
  }

  @override
  Future<bool> hasAccessToken() async {
    final token = await _storage.read(key: supabasePersistSessionKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> accessToken() async {
    return await _storage.read(key: supabasePersistSessionKey);
  }

  @override
  Future<void> removePersistedSession() async {
    await _storage.delete(key: supabasePersistSessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _storage.write(
      key: supabasePersistSessionKey,
      value: persistSessionString,
    );
  }
}
