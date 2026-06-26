import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_text.dart';

/// A reusable error state with optional retry action.
class AppErrorState extends StatelessWidget {
  /// Creates an error state view.
  const AppErrorState({
    super.key,
    this.icon = Icons.error_outline,
    this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedTitle = title ?? l10n.widgetErrorTitle;
    final resolvedMessage = message ?? l10n.widgetErrorMessage;
    final resolvedRetryLabel = retryLabel ?? l10n.widgetActionRetry;

    return Semantics(
      container: true,
      label: '$resolvedTitle. $resolvedMessage',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                resolvedTitle,
                variant: AppTextVariant.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                resolvedMessage,
                variant: AppTextVariant.bodyMedium,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
  }
}
