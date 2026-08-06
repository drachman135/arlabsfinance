import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'dio_interceptor.dart';

/// Dio HTTP client configuration.
///
/// Provides a pre-configured Dio instance with:
/// - Base URL from environment config
/// - Timeouts
/// - Interceptors chain (auth, logging, retry)
///
/// No API calls are made in this sprint — only initialization.
class DioClient {
  DioClient._();

  static Dio? _dio;

  /// Get the configured Dio instance.
  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.supabaseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(
          milliseconds: AppConstants.sendTimeout,
        ),
        headers: {
          ApiConstants.contentType: ApiConstants.applicationJson,
        },
        responseType: ResponseType.json,
      ),
    );

    // Interceptor chain order matters:
    // 1. Auth (add token)
    // 2. Logging (log request/response)
    // 3. Retry (handle failures)
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      RetryInterceptor(),
    ]);

    return dio;
  }

  /// Reset the Dio instance (useful for testing or re-initialization).
  static void reset() {
    _dio?.close();
    _dio = null;
  }
}
