import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// ArLABS reusable dialog component.
///
/// Supports confirmation, alert, and custom content dialogs
/// with glassmorphism-inspired styling.
class AppDialog {
  AppDialog._();

  /// Show a confirmation dialog with title, content, and two actions.
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DialogContent(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDangerous: isDangerous,
      ),
    );
  }

  /// Show an alert dialog with title and content.
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String content,
    String buttonLabel = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.headingMedium),
        content: Text(content, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  /// Show a custom dialog with arbitrary content.
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: child,
        ),
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent({
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDangerous,
  });

  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: AppTextStyles.headingMedium),
      content: Text(content, style: AppTextStyles.bodyMedium),
      actionsPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: cancelLabel,
                variant: AppButtonVariant.outline,
                height: AppDimensions.buttonHeightSmall,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: AppButton(
                label: confirmLabel,
                height: AppDimensions.buttonHeightSmall,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
