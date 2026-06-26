import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../utils/recurring_localization.dart';

class RecurringListItem extends StatelessWidget {
  const RecurringListItem({
    super.key,
    required this.recurring,
    required this.onTap,
    required this.onDelete,
    required this.onPause,
    required this.onResume,
  });

  final RecurringTransaction recurring;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onPause;
  final VoidCallback onResume;

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
                      AppText(
                        recurring.category.name,
                        variant: AppTextVariant.titleSmall,
                      ),
                      AppText(
                        '${context.recurringStatusLabel(recurring.isPaused)} · ${context.recurrenceFrequencyLabel(recurring.frequency)}',
                        variant: AppTextVariant.caption,
                      ),
                      AppText(
                        context.formatRecurringCurrency(recurring.amount),
                        variant: AppTextVariant.bodyMedium,
                      ),
                      AppText(
                        '${context.l10n.recurringNextExecutionLabel}: ${dateFormat.format(recurring.nextExecutionDate)}',
                        variant: AppTextVariant.caption,
                      ),
                    ],
                  ),
                ),
                if (recurring.isPaused)
                  AppIconButton(
                    icon: Icons.play_arrow_outlined,
                    tooltip: context.l10n.recurringResumeAction,
                    onPressed: onResume,
                  )
                else
                  AppIconButton(
                    icon: Icons.pause_outlined,
                    tooltip: context.l10n.recurringPauseAction,
                    onPressed: onPause,
                  ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  tooltip: context.l10n.recurringDeleteAction,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
