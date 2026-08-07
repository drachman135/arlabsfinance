import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

/// Local notification service.
///
/// Initializes Flutter Local Notifications with Android channel.
/// Actual notification scheduling (reminders, etc.) will be added
/// in feature sprints.
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notification service.
  Future<void> init() async {
    if (_isInitialized) return;

    // Skip initialization on web — flutter_local_notifications
    // doesn't support web platform.
    if (kIsWeb) {
      AppLogger.info('Notification service skipped on web platform');
      _isInitialized = true;
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    await _createNotificationChannel();

    _isInitialized = true;
    AppLogger.info('Notification service initialized');
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap — will be implemented in feature sprints.
    AppLogger.debug('Notification tapped: ${response.payload}');
  }

  /// Request notification permissions (Android 13+).
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }
}
