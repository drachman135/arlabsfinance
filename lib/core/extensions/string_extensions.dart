/// String extensions for common operations.
extension StringExtensions on String {
  /// Capitalize first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncate string to [maxLength] with ellipsis.
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Check if string is a valid email.
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid phone number.
  bool get isValidPhone {
    return RegExp(r'^[\+]?[0-9]{10,15}$').hasMatch(replaceAll(RegExp(r'[\s\-]'), ''));
  }

  /// Check if string contains only digits.
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Remove all whitespace.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Get initials from name (e.g., "John Doe" → "JD").
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words.last[0]}'.toUpperCase();
  }
}

/// Nullable string extensions.
extension NullableStringExtensions on String? {
  /// Returns true if string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if string is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the string or a default value if null/empty.
  String orDefault([String defaultValue = '']) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}
