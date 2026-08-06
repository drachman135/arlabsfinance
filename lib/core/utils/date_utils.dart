import 'package:intl/intl.dart';

/// Date formatting utilities using the intl package.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');

  /// Format: 06 Aug 2026
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Format: 06 Aug 2026, 22:10
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Format: 22:10
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Format: 06/08/2026
  static String formatShortDate(DateTime date) => _shortDateFormat.format(date);

  /// Format: 2026-08-06 (for API)
  static String formatApiDate(DateTime date) => _apiDateFormat.format(date);

  /// Format: August 2026
  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);

  /// Parse API date string to DateTime.
  static DateTime? parseApiDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Get relative time string (e.g., "2 hours ago").
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }
}
