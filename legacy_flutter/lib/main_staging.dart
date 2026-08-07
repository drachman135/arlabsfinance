import 'bootstrap.dart';
import 'config/app_environment.dart';

/// Staging entry point.
///
/// Run: flutter run -t lib/main_staging.dart
/// Build: flutter build apk -t lib/main_staging.dart
void main() {
  bootstrap(AppEnvironment.staging);
}
