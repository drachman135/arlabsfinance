import 'app_environment.dart';

/// Flavor configuration for build variants.
///
/// Allows the app to be built with different configurations
/// for Development, Staging, and Production.
class FlavorConfig {
  FlavorConfig._({
    required this.environment,
    required this.appTitle,
  });

  final AppEnvironment environment;
  final String appTitle;

  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance!;

  static void init({
    required AppEnvironment environment,
    String? appTitle,
  }) {
    _instance = FlavorConfig._(
      environment: environment,
      appTitle: appTitle ?? _defaultTitle(environment),
    );
  }

  static String _defaultTitle(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.development:
        return 'ArLABS Finance [DEV]';
      case AppEnvironment.staging:
        return 'ArLABS Finance [STG]';
      case AppEnvironment.production:
        return 'ArLABS Finance';
    }
  }

  bool get isDevelopment => environment.isDevelopment;
  bool get isStaging => environment.isStaging;
  bool get isProduction => environment.isProduction;
}
