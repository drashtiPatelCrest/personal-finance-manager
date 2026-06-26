import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
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
      BudgetStatus.exceeded => AppColors.expense,
      BudgetStatus.warning => AppColors.warning,
      BudgetStatus.normal => AppColors.income,
    };
    final progressValue = (usage.usagePercentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              context.budgetStatusLabel(status),
              variant: AppTextVariant.caption,
              color: progressColor,
            ),
            AppText(
              '${usage.usagePercentage.toStringAsFixed(0)}%',
              variant: AppTextVariant.titleSmall,
              color: progressColor,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: compact ? 6 : 8,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            color: progressColor,
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
