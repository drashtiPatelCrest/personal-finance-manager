import 'package:flutter/material.dart';

import '../theme/app_decorations.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';

/// A theme-aware card container with consistent padding and elevation.
class AppCard extends StatefulWidget {
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
    this.animated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? elevation;
  final String? semanticsLabel;
  final bool animated;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = widget.borderRadius ??
        BorderRadius.circular(AppDimensions.borderRadiusLg);
    final decoration = AppDecorations.card(
      colorScheme: theme.colorScheme,
      backgroundColor: widget.color,
      borderRadius: radius,
      elevated: widget.elevation != 0,
    );

    final content = Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: widget.child,
    );

    final card = AnimatedScale(
      scale: widget.onTap != null && _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: widget.margin ?? EdgeInsets.zero,
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: widget.onTap == null
              ? content
              : InkWell(
                  onTap: widget.onTap,
                  onHighlightChanged: widget.animated
                      ? (value) => setState(() => _pressed = value)
                      : null,
                  borderRadius: radius,
                  splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                  highlightColor:
                      theme.colorScheme.primary.withValues(alpha: 0.04),
                  child: content,
                ),
        ),
      ),
    );

    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticsLabel,
      child: card,
    );
  }
}
