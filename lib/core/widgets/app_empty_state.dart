import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

/// A reusable empty state placeholder for lists and screens.
class AppEmptyState extends StatelessWidget {
  /// Creates an empty state view.
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedTitle = title ?? l10n.widgetEmptyTitle;
    final resolvedMessage = message ?? l10n.widgetEmptyMessage;

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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
