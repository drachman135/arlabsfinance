import 'package:logger/logger.dart';

import '../../config/app_config.dart';

/// Application logger wrapper.
///
/// Verbose in development, minimal in release.
/// All logging goes through this class for consistency.
class AppLogger {
  AppLogger._();

  static late final Logger _logger;

  /// Initialize the logger based on current environment.
  static void init() {
    final isVerbose = AppConfig.instance.enableVerboseLogging;

    _logger = Logger(
      level: isVerbose ? Level.trace : Level.warning,
      printer: PrettyPrinter(
        methodCount: isVerbose ? 2 : 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      output: ConsoleOutput(),
    );
  }

  /// Log a trace message (verbose only).
  static void trace(String message) {
    _logger.t(message);
  }

  /// Log a debug message.
  static void debug(String message) {
    _logger.d(message);
  }

  /// Log an info message.
  static void info(String message) {
    _logger.i(message);
  }

  /// Log a warning message.
  static void warning(String message) {
    _logger.w(message);
  }

  /// Log an error message with optional error and stack trace.
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error.
  static void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
