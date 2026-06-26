import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/savings_goal.dart';
import '../utils/goal_localization.dart';

class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    super.key,
    required this.progress,
    this.compact = false,
  });

  final GoalProgress progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final status = progress.effectiveStatus;
    final progressColor = switch (status) {
      GoalStatus.completed => AppColors.income,
      GoalStatus.expired => AppColors.expense,
      GoalStatus.active => AppColors.savings,
    };
    final progressValue =
        (progress.completionPercentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              context.goalStatusLabel(status),
              variant: AppTextVariant.caption,
              color: progressColor,
            ),
            AppText(
              '${progress.completionPercentage.toStringAsFixed(0)}%',
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
                  label: context.l10n.goalSavedLabel,
                  value: context.formatGoalCurrency(progress.goal.currentAmount),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: context.l10n.goalRemainingLabel,
                  value: context.formatGoalCurrency(
                    progress.goal.remainingAmount.clamp(0, double.infinity),
                  ),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: context.l10n.goalTargetLabel,
                  value: context.formatGoalCurrency(progress.goal.targetAmount),
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
