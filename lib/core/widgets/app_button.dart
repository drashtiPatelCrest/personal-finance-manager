import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

/// Button visual variants.
enum AppButtonVariant { filled, tonal, text }

/// Button size presets.
enum AppButtonSize { small, medium, large }

/// A theme-aware filled or tonal action button.
class AppButton extends StatelessWidget {
  /// Creates an application button.
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isExpanded = false,
    this.isLoading = false,
    this.semanticsLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isExpanded;
  final bool isLoading;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);
    final button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: _style(context),
          child: child,
        ),
      AppButtonVariant.tonal => FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: _style(context),
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _style(context),
          child: child,
        ),
    };

    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      enabled: onPressed != null && !isLoading,
      child: isExpanded ? SizedBox(width: double.infinity, child: button) : button,
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _iconSize(),
        width: _iconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.text
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }

    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: _iconSize()),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  double _iconSize() {
    return switch (size) {
      AppButtonSize.small => AppDimensions.iconSizeSm,
      AppButtonSize.medium => AppDimensions.iconSizeMd,
      AppButtonSize.large => AppDimensions.iconSizeLg,
    };
  }

  ButtonStyle _style(BuildContext context) {
    final height = switch (size) {
      AppButtonSize.small => AppDimensions.buttonHeightSm,
      AppButtonSize.medium => AppDimensions.buttonHeightMd,
      AppButtonSize.large => AppDimensions.buttonHeightLg,
    };

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: size == AppButtonSize.small ? 12 : 16,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
        ),
      ),
    );
  }
}
