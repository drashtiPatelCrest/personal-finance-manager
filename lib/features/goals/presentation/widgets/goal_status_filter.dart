import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/savings_goal.dart';
import '../utils/goal_localization.dart';

class GoalStatusFilter extends StatelessWidget {
  const GoalStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  final GoalStatus? selectedStatus;
  final ValueChanged<GoalStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AppChip(
            label: l10n.goalFilterAll,
            selected: selectedStatus == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: context.goalStatusLabel(GoalStatus.active),
            selected: selectedStatus == GoalStatus.active,
            onTap: () => onChanged(GoalStatus.active),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: context.goalStatusLabel(GoalStatus.completed),
            selected: selectedStatus == GoalStatus.completed,
            onTap: () => onChanged(GoalStatus.completed),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: context.goalStatusLabel(GoalStatus.expired),
            selected: selectedStatus == GoalStatus.expired,
            onTap: () => onChanged(GoalStatus.expired),
          ),
        ],
      ),
    );
  }
}
