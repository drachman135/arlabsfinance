import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../services/supabase_service.dart';
import '../utils/app_logger.dart';

/// Dio interceptors for auth, logging, and retry.
///
/// Auth interceptor: injects token (placeholder — to be connected in auth sprint).
/// Logging interceptor: logs request/response in development.
/// Retry interceptor: structure only, retry logic in future sprint.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final session = SupabaseService.instance.client.auth.currentSession;
    final token = session?.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // Token refresh logic will be added in the auth sprint.
    // if (err.response?.statusCode == 401) {
    //   // Attempt token refresh
    // }
    handler.next(err);
  }
}

/// Logs HTTP requests and responses in development.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (AppConfig.instance.enableVerboseLogging) {
      AppLogger.debug(
        '→ ${options.method} ${options.uri}\n'
        '  Headers: ${options.headers}\n'
        '  Data: ${options.data}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (AppConfig.instance.enableVerboseLogging) {
      AppLogger.debug(
        '← ${response.statusCode} ${response.requestOptions.uri}\n'
        '  Data: ${response.data}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    AppLogger.error(
      '✖ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      '  Error: ${err.message}\n'
      '  Response: ${err.response?.data}',
    );
    handler.next(err);
  }
}

/// Retry interceptor structure.
///
/// Actual retry logic will be implemented when APIs are built.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final int maxRetries;
  final Duration retryDelay;

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // Retry logic placeholder — to be implemented with actual API calls.
    // Only retry on timeout and connection errors, not on 4xx responses.
    handler.next(err);
  }
}
