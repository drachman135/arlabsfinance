import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';

import '../../core/network/dio_client.dart';
import '../../core/services/supabase_service.dart';
import '../../core/storage/secure_storage_service.dart';

/// Provider for the Dio HTTP client.
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

/// Provider for the secure storage service.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService.instance;
});

/// Provider for the Supabase service.
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

/// Provider for the AppDatabase.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
