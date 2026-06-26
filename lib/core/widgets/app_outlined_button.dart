import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import 'app_button.dart';

/// A theme-aware outlined action button.
class AppOutlinedButton extends StatelessWidget {
  /// Creates an outlined application button.
  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isExpanded = false,
    this.isLoading = false,
    this.semanticsLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final IconData? icon;
  final bool isExpanded;
  final bool isLoading;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      AppButtonSize.small => AppDimensions.buttonHeightSm,
      AppButtonSize.medium => AppDimensions.buttonHeightMd,
      AppButtonSize.large => AppDimensions.buttonHeightLg,
    };

    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: AppDimensions.iconSizeMd,
              width: AppDimensions.iconSizeMd,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : icon == null
              ? Text(label)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: AppDimensions.iconSizeMd),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
    );

    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      enabled: onPressed != null && !isLoading,
      child: isExpanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
