import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// A theme-aware icon button with consistent sizing and semantics.
class AppIconButton extends StatelessWidget {
  /// Creates an application icon button.
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = AppDimensions.iconSizeMd,
    this.color,
    this.backgroundColor,
    this.isSelected = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: tooltip,
      selected: isSelected,
      enabled: onPressed != null,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, size: size),
        color: color ?? colorScheme.onSurface,
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
          backgroundColor: backgroundColor ??
              (isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}
