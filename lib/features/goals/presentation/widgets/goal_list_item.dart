import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/savings_goal.dart';
import '../utils/goal_localization.dart';
import 'goal_progress_card.dart';

class GoalListItem extends StatelessWidget {
  const GoalListItem({
    super.key,
    required this.goal,
    required this.progress,
    required this.onTap,
    required this.onDelete,
  });

  final SavingsGoal goal;
  final GoalProgress? progress;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(goal.name, variant: AppTextVariant.titleSmall),
                      AppText(
                        '${context.goalStatusLabel(goal.status)} · ${context.l10n.goalDeadlineLabel}: ${dateFormat.format(goal.deadline)}',
                        variant: AppTextVariant.caption,
                      ),
                      AppText(
                        '${context.formatGoalCurrency(goal.currentAmount)} / ${context.formatGoalCurrency(goal.targetAmount)}',
                        variant: AppTextVariant.bodyMedium,
                      ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  tooltip: context.l10n.goalDeleteAction,
                  onPressed: onDelete,
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: AppSpacing.md),
              GoalProgressCard(progress: progress!, compact: true),
            ],
          ],
        ),
      ),
    );
  }
}
