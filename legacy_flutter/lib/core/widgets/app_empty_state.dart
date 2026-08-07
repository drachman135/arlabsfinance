import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// ArLABS empty state widget.
///
/// Displays when a list or content area has no data.
/// Shows icon, title, subtitle, and optional action button.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconData,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80.0,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final IconData? iconData;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            icon ??
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    iconData ?? Icons.inbox_outlined,
                    size: iconSize * 0.5,
                    color: AppColors.textTertiary,
                  ),
                ),

            const SizedBox(height: AppDimensions.spacing24),

            // Title
            Text(
              title,
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.outline,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
