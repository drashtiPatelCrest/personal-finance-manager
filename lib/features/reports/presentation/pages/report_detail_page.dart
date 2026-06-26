import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../../budgets/presentation/widgets/budget_progress_card.dart';
import '../../../dashboard/presentation/widgets/dashboard_category_chart.dart';
import '../../../dashboard/presentation/widgets/dashboard_income_expense_chart.dart';
import '../../../dashboard/presentation/widgets/dashboard_monthly_trend_chart.dart';
import '../../../goals/presentation/widgets/goal_progress_card.dart';
import '../../domain/entities/financial_report.dart';
import '../bloc/report_detail/report_detail_bloc.dart';
import '../utils/report_chart_adapter.dart';
import '../utils/report_type_parser.dart';
import '../widgets/report_date_range_filter.dart';
import '../widgets/report_summary_metrics.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({
    super.key,
    required this.reportType,
  });

  final ReportType reportType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<ReportDetailBloc>()
        ..add(ReportDetailStarted(reportType)),
      child: BlocConsumer<ReportDetailBloc, ReportDetailState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.reportErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                context.reportTypeLabel(reportType),
                variant: AppTextVariant.titleLarge,
              ),
              actions: [
                AppIconButton(
                  icon: Icons.refresh,
                  tooltip: l10n.reportRefreshAction,
                  onPressed: () => context.read<ReportDetailBloc>().add(
                        const ReportDetailRefreshRequested(),
                      ),
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

  Widget _buildBody(BuildContext context, ReportDetailState state) {
    if (state.isLoading && state.report == null) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.report == null) {
      return AppErrorState(
        onRetry: () => context.read<ReportDetailBloc>().add(
              ReportDetailStarted(reportType),
            ),
      );
    }

    final report = state.report;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReportDetailBloc>().add(const ReportDetailRefreshRequested());
        await context.read<ReportDetailBloc>().stream.firstWhere(
              (next) => !next.isLoading,
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (reportType.supportsDateRangeFilter()) ...[
              ReportDateRangeFilter(
                selectedPreset: state.dateRangePreset,
                onChanged: (preset) => context.read<ReportDetailBloc>().add(
                      ReportDetailDateRangeChanged(preset),
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (reportType.supportsCategoryFilter()) ...[
              _buildCategoryFilter(context, state),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (report == null && state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: AppLoadingIndicator(),
              )
            else if (report != null && !report.hasData)
              AppEmptyState(
                icon: Icons.assessment_outlined,
                title: context.l10n.reportEmptyTitle,
                message: context.l10n.reportEmptyMessage,
              )
            else if (report != null) ...[
              ReportSummaryMetrics(report: report),
              const SizedBox(height: AppSpacing.xl),
              ..._buildCharts(context, report),
              if (report.budgetUsages.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                AppText(
                  context.l10n.reportBudgetSectionTitle,
                  variant: AppTextVariant.titleSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                ...report.budgetUsages.map(
                  (usage) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppCard(
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
              ],
              if (report.goalProgress.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                AppText(
                  context.l10n.reportGoalSectionTitle,
                  variant: AppTextVariant.titleSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                ...report.goalProgress.map(
                  (progress) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AppCard(
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
                            GoalProgressCard(progress: progress, compact: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    ReportDetailState state,
  ) {
    final l10n = context.l10n;
    final categories = state.expenseCategories;

    return AppDropdown<String?>(
      label: l10n.transactionCategoryFilterLabel,
      hint: l10n.categoryFilterAll,
      value: state.selectedCategoryId,
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text(l10n.categoryFilterAll),
        ),
        ...categories.map(
          (category) => DropdownMenuItem<String?>(
            value: category.id,
            child: Text(category.name),
          ),
        ),
      ],
      onChanged: (categoryId) => context.read<ReportDetailBloc>().add(
            ReportDetailCategoryChanged(categoryId),
          ),
    );
  }

  List<Widget> _buildCharts(BuildContext context, FinancialReport report) {
    if (report.type == ReportType.budget || report.type == ReportType.goal) {
      return const [];
    }

    final chartSnapshot = toDashboardChartSnapshot(report);

    return [
      DashboardIncomeExpenseChart(snapshot: chartSnapshot),
      const SizedBox(height: AppSpacing.lg),
      if (report.type != ReportType.category) ...[
        DashboardMonthlyTrendChart(points: chartSnapshot.monthlyTrend),
        const SizedBox(height: AppSpacing.lg),
      ],
      DashboardCategoryChart(items: chartSnapshot.categoryDistribution),
    ];
  }
}
