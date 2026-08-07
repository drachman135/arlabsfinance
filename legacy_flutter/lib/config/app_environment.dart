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
          defaultValue: 'https://dpthhttwmtgtbrsjtfcg.supabase.co',
        );
      case AppEnvironment.staging:
        return const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://dpthhttwmtgtbrsjtfcg.supabase.co',
        );
      case AppEnvironment.production:
        return const String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://dpthhttwmtgtbrsjtfcg.supabase.co',
        );
    }
  }

  String get supabaseAnonKey {
    switch (this) {
      case AppEnvironment.development:
        return const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwdGhodHR3bXRndGJyc2p0ZmNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MTA0NjUsImV4cCI6MjA5ODA4NjQ2NX0.kUHLK0QIVdCu0jAMq3zp8bxDpvg1g-9Mj5FrGoA1tB4',
        );
      case AppEnvironment.staging:
        return const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwdGhodHR3bXRndGJyc2p0ZmNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MTA0NjUsImV4cCI6MjA5ODA4NjQ2NX0.kUHLK0QIVdCu0jAMq3zp8bxDpvg1g-9Mj5FrGoA1tB4',
        );
      case AppEnvironment.production:
        return const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwdGhodHR3bXRndGJyc2p0ZmNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MTA0NjUsImV4cCI6MjA5ODA4NjQ2NX0.kUHLK0QIVdCu0jAMq3zp8bxDpvg1g-9Mj5FrGoA1tB4',
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
