import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../../budgets/presentation/widgets/budget_progress_card.dart';
import '../../../goals/presentation/widgets/goal_progress_card.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../utils/dashboard_localization.dart';
import '../widgets/dashboard_category_chart.dart';
import '../widgets/dashboard_date_range_filter.dart';
import '../widgets/dashboard_income_expense_chart.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/dashboard_monthly_trend_chart.dart';
import '../widgets/dashboard_quick_actions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()..add(const DashboardStarted()),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.dashboardErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.dashboardTitle,
                variant: AppTextVariant.titleLarge,
              ),
              actions: [
                AppIconButton(
                  icon: Icons.assessment_outlined,
                  tooltip: l10n.reportListTitle,
                  onPressed: () => context.push(RoutePaths.reports),
                ),
                AppIconButton(
                  icon: Icons.refresh,
                  tooltip: l10n.dashboardRefreshAction,
                  onPressed: () => context.read<DashboardBloc>().add(
                        const DashboardRefreshRequested(),
                      ),
                ),
                AppIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: l10n.settingsTitle,
                  onPressed: () => context.push(RoutePaths.settings),
                ),
              ],
            ),
            bodyPadding: context.horizontalPagePadding,
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state) {
    if (state.isLoading && state.snapshot == null) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.snapshot == null) {
      return AppErrorState(
        onRetry: () => context.read<DashboardBloc>().add(
              const DashboardStarted(),
            ),
      );
    }

    final snapshot = state.snapshot;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const DashboardRefreshRequested());
        await context.read<DashboardBloc>().stream.firstWhere(
              (next) => !next.isLoading,
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardDateRangeFilter(
              selectedPreset: state.dateRangePreset,
              onChanged: (preset) => context.read<DashboardBloc>().add(
                    DashboardDateRangeChanged(preset),
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (snapshot == null && state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: AppLoadingIndicator(),
              )
            else if (snapshot != null &&
                !snapshot.hasTransactions &&
                snapshot.budgetUsages.isEmpty &&
                snapshot.activeGoals.isEmpty)
              AppEmptyState(
                icon: Icons.dashboard_outlined,
                title: snapshot.hasAnyTransactions
                    ? context.l10n.dashboardRangeEmptyTitle
                    : context.l10n.dashboardEmptyTitle,
                message: snapshot.hasAnyTransactions
                    ? context.l10n.dashboardRangeEmptyMessage
                    : context.l10n.dashboardEmptyMessage,
                action: const DashboardQuickActions(),
              )
            else if (snapshot != null) ...[
              _buildMetricCards(context, snapshot),
              const SizedBox(height: AppSpacing.xl),
              DashboardIncomeExpenseChart(snapshot: snapshot),
              const SizedBox(height: AppSpacing.lg),
              DashboardMonthlyTrendChart(points: snapshot.monthlyTrend),
              const SizedBox(height: AppSpacing.lg),
              DashboardCategoryChart(items: snapshot.categoryDistribution),
              const SizedBox(height: AppSpacing.xl),
              if (snapshot.budgetUsages.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  title: context.l10n.dashboardBudgetUsageTitle,
                  onViewAll: () => context.push(RoutePaths.budgets),
                ),
                const SizedBox(height: AppSpacing.md),
                ...snapshot.budgetUsages.take(3).map(
                      (usage) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          onTap: () => context.push(
                            RoutePaths.budgetDetailPath(usage.budget.id),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  usage.budget.name,
                                  variant: AppTextVariant.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                BudgetProgressCard(usage: usage, compact: true),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (snapshot.activeGoals.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  title: context.l10n.dashboardActiveGoalsTitle(
                    snapshot.activeGoalsCount,
                  ),
                  onViewAll: () => context.push(RoutePaths.goals),
                ),
                const SizedBox(height: AppSpacing.md),
                ...snapshot.activeGoals.take(3).map(
                      (progress) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          onTap: () => context.push(
                            RoutePaths.goalDetailPath(progress.goal.id),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  progress.goal.name,
                                  variant: AppTextVariant.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                GoalProgressCard(
                                  progress: progress,
                                  compact: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: AppSpacing.lg),
              ],
              const DashboardQuickActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCards(BuildContext context, snapshot) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        final children = [
          DashboardMetricCard(
            label: l10n.dashboardTotalIncomeLabel,
            value: context.formatCurrency(snapshot.totalIncome),
            icon: Icons.trending_up,
            color: AppColors.income,
            onTap: () => context.push(RoutePaths.transactions),
          ),
          DashboardMetricCard(
            label: l10n.dashboardTotalExpenseLabel,
            value: context.formatCurrency(snapshot.totalExpense),
            icon: Icons.trending_down,
            color: AppColors.expense,
            onTap: () => context.push(RoutePaths.transactions),
          ),
          DashboardMetricCard(
            label: l10n.dashboardTotalSavingsLabel,
            value: context.formatCurrency(snapshot.totalSavings),
            icon: Icons.savings_outlined,
            color: AppColors.savings,
            onTap: () => context.push(RoutePaths.goals),
          ),
          DashboardMetricCard(
            label: l10n.dashboardNetBalanceLabel,
            value: context.formatCurrency(snapshot.netBalance),
            icon: Icons.account_balance_wallet_outlined,
            color: snapshot.netBalance >= 0
                ? AppColors.income
                : AppColors.expense,
          ),
        ];

        if (isWide) {
          return Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: children[i]),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              children[i],
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      children: [
        Expanded(
          child: AppText(title, variant: AppTextVariant.titleSmall),
        ),
        TextButton(
          onPressed: onViewAll,
          child: AppText(
            context.l10n.dashboardViewAllAction,
            variant: AppTextVariant.bodyMedium,
          ),
        ),
      ],
    );
  }
}
