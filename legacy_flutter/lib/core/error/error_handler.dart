import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_logger.dart';
import 'app_exception.dart';
import 'failure.dart';

/// Global error handler.
///
/// Maps platform-specific errors (DioException, etc.) to domain failures.
/// Provides a centralized place for error logging and transformation.
class ErrorHandler {
  ErrorHandler._();

  /// Initialize global error handling for the app.
  static void init() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.error(
        'Flutter Error',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Catch async errors not caught by the framework
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLogger.error(
        'Platform Error',
        error: error,
        stackTrace: stack,
      );
      return true;
    };
  }

  /// Convert a [DioException] to a typed [AppException].
  static AppException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException(
          message: 'Connection timed out',
          cause: error,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Unable to connect to server',
          cause: error,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return ServerException(
          message: 'Request cancelled',
          cause: error,
        );

      case DioExceptionType.badCertificate:
        return ServerException(
          message: 'Invalid certificate',
          cause: error,
        );

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return const NetworkException();
        }
        return UnknownException(
          message: error.message ?? 'An unknown error occurred',
          cause: error,
        );
    }
  }

  static AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'Server error';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'].toString();
    }

    if (statusCode == 401 || statusCode == 403) {
      return AuthException(
        message: message,
        statusCode: statusCode,
        cause: error,
      );
    }

    return ServerException(
      message: message,
      statusCode: statusCode,
      cause: error,
    );
  }

  /// Convert an [AppException] to a [Failure] for the domain layer.
  static Failure exceptionToFailure(AppException exception) {
    return switch (exception) {
      ServerException() => ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      CacheException() => CacheFailure(message: exception.message),
      NetworkException() => const NetworkFailure(),
      TimeoutException() => const TimeoutFailure(),
      AuthException() => AuthFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      UnknownException() => UnknownFailure(message: exception.message),
    };
  }

  /// Generic error handler that converts any error to a [Failure].
  static Failure handleError(Object error, [StackTrace? stackTrace]) {
    AppLogger.error('Unhandled error', error: error, stackTrace: stackTrace);

    if (error is DioException) {
      return exceptionToFailure(handleDioError(error));
    }

    if (error is AppException) {
      return exceptionToFailure(error);
    }

    if (error is FormatException) {
      return ServerFailure(message: 'Invalid data format: ${error.message}');
    }

    if (error is TimeoutException) {
      return const TimeoutFailure();
    }

    return UnknownFailure(message: error.toString());
  }
}
