/// Custom exception types for the application.
///
/// Typed exceptions allow precise error handling across layers.
sealed class AppException implements Exception {
  const AppException({required this.message, this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final dynamic cause;

  @override
  String toString() => 'AppException($runtimeType): $message';
}

/// Server returned an error response.
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.cause,
  });
}

/// Local cache/database operation failed.
class CacheException extends AppException {
  const CacheException({required super.message, super.cause});
}

/// No internet connection.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.cause,
  });
}

/// Request timed out.
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.cause,
  });
}

/// Authentication failed or token expired.
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.statusCode,
    super.cause,
  });
}

/// Unknown/unhandled error.
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unknown error occurred',
    super.cause,
  });
}
