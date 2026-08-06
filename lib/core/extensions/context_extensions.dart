import 'package:flutter/material.dart';

/// BuildContext extensions for convenient access.
extension ContextExtensions on BuildContext {
  // ─── Theme ───
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // ─── Media Query ───
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  double get statusBarHeight => padding.top;
  double get bottomBarHeight => padding.bottom;

  // ─── Platform ───
  bool get isPortrait =>
      mediaQuery.orientation == Orientation.portrait;
  bool get isLandscape =>
      mediaQuery.orientation == Orientation.landscape;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // ─── Navigation ───
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  bool get canPop => Navigator.of(this).canPop();

  // ─── Snackbar ───
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  // ─── Focus ───
  void unfocus() => FocusScope.of(this).unfocus();
}
