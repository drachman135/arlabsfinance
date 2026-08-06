import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'config/app_environment.dart';
import 'config/flavor_config.dart';
import 'core/error/error_handler.dart';
import 'core/notification/notification_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/supabase_service.dart';
import 'core/utils/app_logger.dart';

/// Bootstrap the application with the given [environment].
///
/// Initializes all core services in the correct order:
/// 1. AppConfig (environment)
/// 2. FlavorConfig (build variant)
/// 3. Logger
/// 4. Error Handler
/// 5. Supabase
/// 6. Connectivity
/// 7. Notifications
///
/// Then runs the app wrapped in ProviderScope.
Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. App Config
  AppConfig.instance.init(environment: environment);

  // 2. Flavor Config
  FlavorConfig.init(environment: environment);

  // 3. Logger
  AppLogger.init();
  AppLogger.info('Starting ArLABS Finance Client [${environment.name}]');

  // 4. Error Handler
  ErrorHandler.init();

  // 5. Supabase
  await SupabaseService.instance.init();

  // 6. Connectivity
  await ConnectivityService.instance.init();

  // 7. Notifications
  await NotificationService.instance.init();

  AppLogger.info('All services initialized successfully');

  // Run the app
  runApp(
    const ProviderScope(
      child: ArLabsFinanceApp(),
    ),
  );
}
