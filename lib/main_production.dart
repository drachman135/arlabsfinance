import 'bootstrap.dart';
import 'config/app_environment.dart';

/// Production entry point.
///
/// Run: flutter run -t lib/main_production.dart
/// Build: flutter build apk -t lib/main_production.dart
void main() {
  bootstrap(AppEnvironment.production);
}
