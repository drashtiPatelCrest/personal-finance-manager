import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_spacing.dart';
import 'app_shimmer_loader.dart';

/// A theme-aware loading indicator with accessibility support.
class AppLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator.
  const AppLoadingIndicator({
    super.key,
    this.size = 36,
    this.strokeWidth = 3,
    this.color,
    this.semanticsLabel,
    this.message,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final String? semanticsLabel;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: semanticsLabel ?? l10n.widgetLoading,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                color: color ?? colorScheme.primary,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder layout for dashboard-style loading states.
class AppDashboardSkeleton extends StatelessWidget {
  const AppDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppShimmerLoader(
            height: 40,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < 4; i++) ...[
            const AppShimmerLoader(
              height: 96,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const AppShimmerLoader(
            height: 240,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ],
      ),
    );
  }
}
