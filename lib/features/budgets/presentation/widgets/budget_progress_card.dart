import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/budget.dart';
import '../utils/budget_localization.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.usage,
    this.compact = false,
  });

  final BudgetUsage usage;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final status = usage.status;
    final progressColor = switch (status) {
      BudgetStatus.exceeded => Theme.of(context).colorScheme.error,
      BudgetStatus.warning => Theme.of(context).colorScheme.tertiary,
      BudgetStatus.normal => Theme.of(context).colorScheme.primary,
    };
    final progressValue = (usage.usagePercentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: AppDecorations.metricAccent(
                accentColor: progressColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusFull),
              ),
              child: AppText(
                context.budgetStatusLabel(status),
                variant: AppTextVariant.caption,
                color: progressColor,
              ),
            ),
            Text(
              '${usage.usagePercentage.toStringAsFixed(0)}%',
              style: AppTextStyles.money(context, color: progressColor),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusFull),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progressValue),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: compact ? 8 : 10,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                color: progressColor,
              );
            },
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: context.l10n.budgetSpentLabel,
                  value: context.formatBudgetCurrency(usage.spentAmount),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: context.l10n.budgetRemainingLabel,
                  value: context.formatBudgetCurrency(usage.remainingAmount),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: context.l10n.budgetLimitLabel,
                  value: context.formatBudgetCurrency(usage.budget.amount),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, variant: AppTextVariant.caption),
        const SizedBox(height: AppSpacing.xs),
        AppText(value, variant: AppTextVariant.titleSmall),
      ],
    );
  }
}
