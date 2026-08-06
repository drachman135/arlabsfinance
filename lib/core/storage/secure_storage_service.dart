import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

/// Secure storage service for sensitive data.
///
/// Wraps Flutter Secure Storage for token and session management.
/// Uses platform-specific secure storage (Android Keystore, Web).
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService _instance = SecureStorageService._();
  static SecureStorageService get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    webOptions: WebOptions(dbName: 'arlabs_secure', publicKey: 'arlabs'),
  );

  // ─── Access Token ───

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read access token', error: e);
      return null;
    }
  }

  Future<void> setAccessToken(String token) async {
    try {
      await _storage.write(key: AppConstants.accessTokenKey, value: token);
    } catch (e) {
      AppLogger.error('Failed to write access token', error: e);
    }
  }

  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: AppConstants.accessTokenKey);
    } catch (e) {
      AppLogger.error('Failed to delete access token', error: e);
    }
  }

  // ─── Refresh Token ───

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      AppLogger.error('Failed to read refresh token', error: e);
      return null;
    }
  }

  Future<void> setRefreshToken(String token) async {
    try {
      await _storage.write(key: AppConstants.refreshTokenKey, value: token);
    } catch (e) {
      AppLogger.error('Failed to write refresh token', error: e);
    }
  }

  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: AppConstants.refreshTokenKey);
    } catch (e) {
      AppLogger.error('Failed to delete refresh token', error: e);
    }
  }

  // ─── Session ───

  Future<String?> getSessionData() async {
    try {
      return await _storage.read(key: AppConstants.sessionKey);
    } catch (e) {
      AppLogger.error('Failed to read session data', error: e);
      return null;
    }
  }

  Future<void> setSessionData(String data) async {
    try {
      await _storage.write(key: AppConstants.sessionKey, value: data);
    } catch (e) {
      AppLogger.error('Failed to write session data', error: e);
    }
  }

  // ─── User ID ───

  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: AppConstants.userIdKey);
    } catch (e) {
      AppLogger.error('Failed to read user ID', error: e);
      return null;
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _storage.write(key: AppConstants.userIdKey, value: userId);
    } catch (e) {
      AppLogger.error('Failed to write user ID', error: e);
    }
  }

  // ─── Generic ───

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Clear all stored data (e.g., on logout).
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('Secure storage cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', error: e);
    }
  }
}
