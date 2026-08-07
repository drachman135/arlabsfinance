import 'package:logger/logger.dart';

/// Placeholder service for FCM / Push Notifications integration.
class FCMNotificationService {
  final Logger _logger = Logger();

  Future<void> initialize() async {
    _logger.i('FCM Notification Service initialized (Mock)');
  }

  void handleNotificationTap(String? payload) {
    if (payload != null) {
      _logger.i('Navigating to chat room: $payload');
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    _logger.i('Mock Push Notification Received: $title - $body');
  }
}
