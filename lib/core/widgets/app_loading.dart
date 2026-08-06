import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// ArLABS global loading widget.
///
/// Provides overlay and inline loading indicators.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.message,
    this.size = 40.0,
  });

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArLabsLoader(size: size),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Show a full-screen loading overlay.
  static Widget overlay({String? message}) {
    return Container(
      color: AppColors.backgroundDark.withValues(alpha: 0.7),
      child: AppLoading(message: message),
    );
  }

  /// Inline small loading indicator.
  static Widget inline({double size = 20.0}) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.primary,
      ),
    );
  }
}

/// ArLABS branded loading animation.
///
/// A pulsing gradient circle with the ArLABS brand colors.
class _ArLabsLoader extends StatefulWidget {
  const _ArLabsLoader({this.size = 40.0});

  final double size;

  @override
  State<_ArLabsLoader> createState() => _ArLabsLoaderState();
}

class _ArLabsLoaderState extends State<_ArLabsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Icon(
                Icons.account_balance,
                color: AppColors.textPrimary,
                size: widget.size * 0.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
