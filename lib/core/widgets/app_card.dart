import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';

/// A theme-aware card container with consistent padding and elevation.
class AppCard extends StatelessWidget {
  /// Creates an application card.
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.borderRadius,
    this.elevation,
    this.semanticsLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? elevation;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius ??
          BorderRadius.circular(AppDimensions.borderRadiusMd),
      side: BorderSide(color: theme.colorScheme.outlineVariant),
    );

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    final card = Card(
      color: color,
      elevation: elevation ?? 0,
      margin: margin ?? EdgeInsets.zero,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              child: content,
            ),
    );

    return Semantics(
      button: onTap != null,
      label: semanticsLabel,
      child: card,
    );
  }
}
