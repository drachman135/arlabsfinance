import 'app_environment.dart';

/// Global application configuration.
///
/// Initialized once at app startup from the flavor-specific entry point.
/// Provides access to the current environment and its configuration values.
class AppConfig {
  AppConfig._();

  static final AppConfig _instance = AppConfig._();
  static AppConfig get instance => _instance;

  late AppEnvironment _environment;

  /// Initialize app config with the target environment.
  void init({required AppEnvironment environment}) {
    _environment = environment;
  }

  AppEnvironment get environment => _environment;

  String get supabaseUrl => _environment.supabaseUrl;
  String get supabaseAnonKey => _environment.supabaseAnonKey;

  bool get isDevelopment => _environment.isDevelopment;
  bool get isStaging => _environment.isStaging;
  bool get isProduction => _environment.isProduction;

  /// Whether verbose logging is enabled.
  bool get enableVerboseLogging => !_environment.isProduction;
}
