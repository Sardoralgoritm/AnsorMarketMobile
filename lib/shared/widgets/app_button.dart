import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.minimumSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    final effectiveSize =
        minimumSize ?? const Size(double.infinity, 52);
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Text(label);

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: effectiveSize,
            backgroundColor: AppColors.primary,
          ),
          child: child,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: effectiveSize,
          ),
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: effectiveSize,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
          ),
          child: Text(label),
        );
    }
  }
}
