/// Environment configuration for ArLABS Finance Client.
///
/// Defines the available environments and their Supabase credentials.
/// URL and Anon Key are loaded per environment — never hardcoded.
enum AppEnvironment {
  development,
  staging,
  production,
}

/// Extension to provide environment-specific Supabase configuration.
extension AppEnvironmentConfig on AppEnvironment {
  String get supabaseUrl {
    switch (this) {
      case AppEnvironment.development:
        return const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://dev.supabase.co',
        );
      case AppEnvironment.staging:
        return const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://staging.supabase.co',
        );
      case AppEnvironment.production:
        return const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://prod.supabase.co',
        );
    }
  }

  String get supabaseAnonKey {
    switch (this) {
      case AppEnvironment.development:
        return const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'dev-anon-key',
        );
      case AppEnvironment.staging:
        return const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'staging-anon-key',
        );
      case AppEnvironment.production:
        return const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'prod-anon-key',
        );
    }
  }

  String get name {
    switch (this) {
      case AppEnvironment.development:
        return 'Development';
      case AppEnvironment.staging:
        return 'Staging';
      case AppEnvironment.production:
        return 'Production';
    }
  }

  bool get isDevelopment => this == AppEnvironment.development;
  bool get isStaging => this == AppEnvironment.staging;
  bool get isProduction => this == AppEnvironment.production;
}
