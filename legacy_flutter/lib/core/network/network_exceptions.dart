import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// Typed network exceptions derived from Dio errors.
///
/// Maps HTTP status codes to meaningful exception types.
class NetworkExceptions {
  NetworkExceptions._();

  /// Convert a DioException to a typed AppException.
  static AppException fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _fromStatusCode(
          error.response?.statusCode,
          error.response?.data,
        );

      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Invalid SSL certificate');

      case DioExceptionType.unknown:
        return const UnknownException();
    }
  }

  static AppException _fromStatusCode(int? statusCode, dynamic data) {
    final message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return ServerException(
          message: message ?? 'Bad request',
          statusCode: 400,
        );
      case 401:
        return AuthException(message: message ?? 'Unauthorized', statusCode: 401);
      case 403:
        return AuthException(message: message ?? 'Forbidden', statusCode: 403);
      case 404:
        return ServerException(
          message: message ?? 'Not found',
          statusCode: 404,
        );
      case 409:
        return ServerException(
          message: message ?? 'Conflict',
          statusCode: 409,
        );
      case 422:
        return ServerException(
          message: message ?? 'Validation error',
          statusCode: 422,
        );
      case 429:
        return ServerException(
          message: message ?? 'Too many requests',
          statusCode: 429,
        );
      case 500:
        return ServerException(
          message: message ?? 'Internal server error',
          statusCode: 500,
        );
      case 502:
        return ServerException(
          message: message ?? 'Bad gateway',
          statusCode: 502,
        );
      case 503:
        return ServerException(
          message: message ?? 'Service unavailable',
          statusCode: 503,
        );
      default:
        return ServerException(
          message: message ?? 'Server error',
          statusCode: statusCode,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    if (data is String) return data;
    return null;
  }
}
