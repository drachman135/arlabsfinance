import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// ArLABS reusable bottom sheet component.
///
/// Draggable bottom sheet with handle indicator and ArLABS styling.
class AppBottomSheet {
  AppBottomSheet._();

  /// Show a modal bottom sheet with custom content.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight)
          : null,
      builder: (context) => _BottomSheetContent(
        title: title,
        child: child,
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({
    this.title,
    required this.child,
  });

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: AppDimensions.spacing12),
          Container(
            width: AppDimensions.bottomSheetHandleWidth,
            height: AppDimensions.bottomSheetHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusCircle,
              ),
            ),
          ),

          // Title
          if (title != null) ...[
            const SizedBox(height: AppDimensions.spacing16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
              ),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const Divider(height: AppDimensions.spacing24),
          ] else
            const SizedBox(height: AppDimensions.spacing8),

          // Content
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
              ),
              child: child,
            ),
          ),

          const SizedBox(height: AppDimensions.spacing16),
        ],
      ),
    );
  }
}
