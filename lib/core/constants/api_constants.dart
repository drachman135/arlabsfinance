/// API endpoint constants.
///
/// Placeholder structure — actual endpoints will be added
/// in feature sprints.
class ApiConstants {
  ApiConstants._();

  // Base paths
  static const String apiVersion = '/v1';

  // Auth endpoints (placeholder)
  static const String authLogin = '$apiVersion/auth/login';
  static const String authLogout = '$apiVersion/auth/logout';
  static const String authRefresh = '$apiVersion/auth/refresh';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}
