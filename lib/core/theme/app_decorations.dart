import 'package:flutter/material.dart';

import 'app_dimensions.dart';
import 'app_spacing.dart';

/// Shared visual decorations for cards, surfaces, and accents.
abstract final class AppDecorations {
  static BoxDecoration card({
    required ColorScheme colorScheme,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    bool elevated = true,
  }) {
    final radius = borderRadius ??
        BorderRadius.circular(AppDimensions.borderRadiusLg);

    return BoxDecoration(
      color: backgroundColor ?? colorScheme.surfaceContainerLowest,
      borderRadius: radius,
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.6),
      ),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration metricAccent({
    required Color accentColor,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: accentColor.withValues(alpha: 0.1),
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppDimensions.borderRadiusMd),
    );
  }

  static BoxDecoration iconBadge({
    required Color color,
    double size = 44,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
    );
  }

  static EdgeInsets pagePadding({
    required bool isDesktop,
    required bool isTablet,
  }) {
    if (isDesktop) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.lg,
      );
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      );
    }
    return const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    );
  }
}
