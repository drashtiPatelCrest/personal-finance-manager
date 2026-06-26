import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          l10n.dashboardQuickActionsTitle,
          variant: AppTextVariant.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppChip(
              label: l10n.dashboardQuickAddTransaction,
              onTap: () => context.push(RoutePaths.transactionAdd),
            ),
            AppChip(
              label: l10n.dashboardQuickAddBudget,
              onTap: () => context.push(RoutePaths.budgetAdd),
            ),
            AppChip(
              label: l10n.dashboardQuickAddGoal,
              onTap: () => context.push(RoutePaths.goalAdd),
            ),
            AppChip(
              label: l10n.dashboardQuickViewTransactions,
              onTap: () => context.push(RoutePaths.transactions),
            ),
          ],
        ),
      ],
    );
  }
}
