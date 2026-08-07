import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arlabs_finance_client/app.dart';
import 'package:arlabs_finance_client/config/app_environment.dart';
import 'package:arlabs_finance_client/config/flavor_config.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    FlavorConfig.init(environment: AppEnvironment.development);
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ArLabsFinanceApp()));

    // Verify that the app builds without crashing.
    expect(find.byType(ArLabsFinanceApp), findsOneWidget);
  });
}
