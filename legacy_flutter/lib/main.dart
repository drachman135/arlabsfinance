import 'bootstrap.dart';
import 'config/app_environment.dart';

/// Default entry point — delegates to Development environment.
///
/// Run: flutter run
void main() {
  bootstrap(AppEnvironment.development);
}
