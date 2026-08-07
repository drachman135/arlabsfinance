import 'bootstrap.dart';
import 'config/app_environment.dart';

/// Development entry point.
///
/// Run: flutter run -t lib/main_development.dart
/// Build: flutter build apk -t lib/main_development.dart
void main() {
  bootstrap(AppEnvironment.development);
}
