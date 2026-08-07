import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// ArLABS reusable card component.
///
/// Glassmorphism-styled card with subtle border and blur effect.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.useGlassmorphism = false,
    this.borderColor,
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool useGlassmorphism;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimensions.radiusLarge;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: useGlassmorphism
            ? AppColors.glassSurface
            : (backgroundColor ?? AppColors.surface),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: useGlassmorphism
              ? AppColors.glassBorder
              : (borderColor ?? AppColors.border),
        ),
      ),
      child: useGlassmorphism
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: padding ??
                      const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: child,
                ),
              ),
            )
          : Padding(
              padding: padding ??
                  const EdgeInsets.all(AppDimensions.paddingMedium),
              child: child,
            ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
