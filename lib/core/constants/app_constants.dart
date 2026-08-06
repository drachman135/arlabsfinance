/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'ArLABS Finance';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.ardevlabs.finance.client';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String sessionKey = 'session_data';
  static const String userIdKey = 'user_id';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Retry
  static const int maxRetryAttempts = 3;
  static const int retryDelayMs = 1000;

  // Database
  static const String databaseName = 'arlabs_finance_db';

  // Notification
  static const String notificationChannelId = 'arlabs_finance_channel';
  static const String notificationChannelName = 'ArLABS Finance';
  static const String notificationChannelDescription =
      'Notifications for ArLABS Finance Client';
}
