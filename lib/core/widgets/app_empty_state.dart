import 'package:flutter/material.dart';

import '../l10n/l10n_extensions.dart';
import '../theme/app_decorations.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_spacing.dart';
import 'app_fade_in.dart';
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
    this.animate = true,
  });

  final IconData icon;
  final String? title;
  final String? message;
  final Widget? action;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedTitle = title ?? l10n.widgetEmptyTitle;
    final resolvedMessage = message ?? l10n.widgetEmptyMessage;
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
                  color: colorScheme.primary,
                  size: 80,
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconSizeXl,
                  color: colorScheme.primary,
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
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );

    return animate ? AppFadeIn(child: content) : content;
  }
}
