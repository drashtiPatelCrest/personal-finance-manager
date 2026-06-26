import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/budget.dart';
import '../utils/budget_localization.dart';
import 'budget_progress_card.dart';

class BudgetListItem extends StatelessWidget {
  const BudgetListItem({
    super.key,
    required this.budget,
    required this.usage,
    required this.onTap,
    required this.onDelete,
  });

  final Budget budget;
  final BudgetUsage? usage;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    final period =
        '${dateFormat.format(budget.startDate)} - ${dateFormat.format(budget.endDate)}';

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
                      AppText(budget.name, variant: AppTextVariant.titleSmall),
                      AppText(
                        '${context.budgetTypeLabel(budget.type)} · $period',
                        variant: AppTextVariant.caption,
                      ),
                      AppText(
                        context.formatBudgetCurrency(budget.amount),
                        variant: AppTextVariant.bodyMedium,
                      ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  tooltip: context.l10n.budgetDeleteAction,
                  onPressed: onDelete,
                ),
              ],
            ),
            if (usage != null) ...[
              const SizedBox(height: AppSpacing.md),
              BudgetProgressCard(usage: usage!, compact: true),
            ],
          ],
        ),
      ),
    );
  }
}
