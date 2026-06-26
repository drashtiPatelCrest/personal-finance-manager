import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_decorations.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_fade_in.dart';
import 'app_text.dart';

/// A reusable error state with optional retry action.
class AppErrorState extends StatelessWidget {
  /// Creates an error state view.
  const AppErrorState({
    super.key,
    this.icon = Icons.error_outline_rounded,
    this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
    this.animate = true,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedTitle = title ?? l10n.widgetErrorTitle;
    final resolvedMessage = message ?? l10n.widgetErrorMessage;
    final resolvedRetryLabel = retryLabel ?? l10n.widgetActionRetry;
    final colorScheme = Theme.of(context).colorScheme;

    final content = Semantics(
      container: true,
      label: '$resolvedTitle. $resolvedMessage',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: AppDecorations.iconBadge(
                  color: colorScheme.error,
                  size: 80,
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconSizeXl,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppText(
                resolvedTitle,
                variant: AppTextVariant.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                resolvedMessage,
                variant: AppTextVariant.bodyMedium,
                color: colorScheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: resolvedRetryLabel,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return animate ? AppFadeIn(child: content) : content;
  }
}
