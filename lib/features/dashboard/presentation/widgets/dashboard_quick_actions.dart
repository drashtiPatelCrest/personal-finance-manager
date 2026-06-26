import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import 'dashboard_quick_action_tile.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brightness = Theme.of(context).brightness;

    final actions = [
      _QuickActionData(
        label: l10n.dashboardQuickAddTransaction,
        icon: Icons.add_circle_outline,
        color: AppColors.incomeFor(brightness),
        onTap: () => context.push(RoutePaths.transactionAdd),
      ),
      _QuickActionData(
        label: l10n.dashboardQuickAddCategory,
        icon: Icons.category_outlined,
        color: Theme.of(context).colorScheme.tertiary,
        onTap: () => context.push(RoutePaths.categoryAdd),
      ),
      _QuickActionData(
        label: l10n.dashboardQuickAddBudget,
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.warningFor(brightness),
        onTap: () => context.push(RoutePaths.budgetAdd),
      ),
      _QuickActionData(
        label: l10n.dashboardQuickAddGoal,
        icon: Icons.savings_outlined,
        color: AppColors.savingsFor(brightness),
        onTap: () => context.push(RoutePaths.goalAdd),
      ),
      _QuickActionData(
        label: l10n.dashboardQuickViewTransactions,
        icon: Icons.receipt_long_outlined,
        color: Theme.of(context).colorScheme.primary,
        onTap: () => context.push(RoutePaths.transactions),
      ),
    ];

    return AppFadeIn(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(title: l10n.dashboardQuickActionsTitle),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = _resolveCrossAxisCount(
                constraints.maxWidth,
                context.isDesktop,
              );
              const spacing = AppSpacing.md;
              final tileWidth =
                  (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                      crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final action in actions)
                    SizedBox(
                      width: tileWidth,
                      child: DashboardQuickActionTile(
                        label: action.label,
                        icon: action.icon,
                        color: action.color,
                        onTap: action.onTap,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  int _resolveCrossAxisCount(double width, bool isDesktop) {
    if (width >= 720 || isDesktop) {
      return 3;
    }
    if (width >= 420) {
      return 2;
    }
    return 2;
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
