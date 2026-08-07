import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_config.dart';
import '../utils/app_logger.dart';
import 'secure_local_storage.dart';

/// Supabase service for initialization and access.
///
/// URL and Anon Key come from AppConfig (environment-specific).
/// No login or queries in this sprint.
class SupabaseService {
  SupabaseService._();

  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  bool _isInitialized = false;

  /// Initialize Supabase with environment-specific configuration.
  Future<void> init() async {
    if (_isInitialized) return;

    await Supabase.initialize(
      url: AppConfig.instance.supabaseUrl,
      publishableKey: AppConfig.instance.supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(
        localStorage: SecureLocalStorage(),
      ),
    );

    _isInitialized = true;
    AppLogger.info(
      'Supabase initialized for ${AppConfig.instance.environment.name}',
    );
  }

  /// Get the Supabase client instance.
  SupabaseClient get client => Supabase.instance.client;

  /// Check if Supabase is initialized.
  bool get isInitialized => _isInitialized;
}
