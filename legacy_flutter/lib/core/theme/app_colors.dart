import 'package:flutter/material.dart';

/// ArLABS brand color palette.
///
/// Designed to match the ArLABS ecosystem visual identity.
/// Dark theme first — consistent with Android Owner app.
class AppColors {
  AppColors._();

  // ─── Brand Primary ───
  static const Color primary = Color(0xFF3949AB);
  static const Color primaryDark = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF5C6BC0);
  static const Color primarySurface = Color(0xFF283593);

  // ─── Brand Accent ───
  static const Color accent = Color(0xFFFFB300);
  static const Color accentLight = Color(0xFFFFCA28);
  static const Color accentDark = Color(0xFFFF8F00);

  // ─── Background ───
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color backgroundSecondary = Color(0xFF161B22);

  // ─── Surface ───
  static const Color surface = Color(0xFF1C2128);
  static const Color surfaceLight = Color(0xFF2D333B);
  static const Color surfaceElevated = Color(0xFF343B45);

  // ─── Glassmorphism ───
  static Color glassSurface = Colors.white.withValues(alpha: 0.05);
  static Color glassBorder = Colors.white.withValues(alpha: 0.10);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.15);

  // ─── Text ───
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textTertiary = Color(0xFF6E7681);
  static const Color textDisabled = Color(0xFF484F58);

  // ─── Semantic ───
  static const Color success = Color(0xFF2EA043);
  static const Color successLight = Color(0xFF56D364);
  static const Color error = Color(0xFFDA3633);
  static const Color errorLight = Color(0xFFF85149);
  static const Color warning = Color(0xFFD29922);
  static const Color warningLight = Color(0xFFE3B341);
  static const Color info = Color(0xFF388BFD);
  static const Color infoLight = Color(0xFF58A6FF);

  // ─── Divider & Border ───
  static const Color divider = Color(0xFF21262D);
  static const Color border = Color(0xFF30363D);
  static const Color borderFocused = Color(0xFF58A6FF);

  // ─── Gradient ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentDark, accent, accentLight],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundDark, backgroundSecondary],
  );

  // ─── Shimmer (Loading) ───
  static const Color shimmerBase = Color(0xFF21262D);
  static const Color shimmerHighlight = Color(0xFF30363D);
}
