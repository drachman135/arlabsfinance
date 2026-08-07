import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// ArLABS reusable snackbar utility.
///
/// Success, error, info, and warning variants with ArLABS styling.
class AppSnackbar {
  AppSnackbar._();

  static void success(BuildContext context, String message) {
    _show(context, message, AppColors.success, Icons.check_circle_outline);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, AppColors.error, Icons.error_outline);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, AppColors.info, Icons.info_outline);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, AppColors.warning, Icons.warning_amber_outlined);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: AppDimensions.iconDefault),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
