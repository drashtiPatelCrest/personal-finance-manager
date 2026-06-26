import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../dashboard/presentation/widgets/dashboard_metric_card.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../../domain/entities/financial_report.dart';

class ReportSummaryMetrics extends StatelessWidget {
  const ReportSummaryMetrics({
    super.key,
    required this.report,
  });

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = report.summary;

    final metrics = switch (report.type) {
      ReportType.budget => [
          _MetricData(
            label: l10n.reportTotalBudgetsLabel,
            value: summary.totalBudgets.toString(),
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.info,
          ),
          _MetricData(
            label: l10n.reportTotalSpentLabel,
            value: context.formatCurrency(summary.totalExpense),
            icon: Icons.payments_outlined,
            color: AppColors.expense,
          ),
          _MetricData(
            label: l10n.reportExceededBudgetsLabel,
            value: summary.exceededBudgetCount.toString(),
            icon: Icons.warning_amber_outlined,
            color: AppColors.expense,
          ),
          _MetricData(
            label: l10n.reportWarningBudgetsLabel,
            value: summary.warningBudgetCount.toString(),
            icon: Icons.info_outline,
            color: AppColors.warning,
          ),
        ],
      ReportType.goal => [
          _MetricData(
            label: l10n.reportTotalSavingsLabel,
            value: context.formatCurrency(summary.totalSavings),
            icon: Icons.savings_outlined,
            color: AppColors.income,
          ),
          _MetricData(
            label: l10n.reportActiveGoalsLabel,
            value: summary.activeGoalCount.toString(),
            icon: Icons.flag_outlined,
            color: AppColors.info,
          ),
          _MetricData(
            label: l10n.reportCompletedGoalsLabel,
            value: summary.completedGoalCount.toString(),
            icon: Icons.check_circle_outline,
            color: AppColors.income,
          ),
        ],
      _ => [
          _MetricData(
            label: l10n.reportTotalIncomeLabel,
            value: context.formatCurrency(summary.totalIncome),
            icon: Icons.trending_up,
            color: AppColors.income,
          ),
          _MetricData(
            label: l10n.reportTotalExpenseLabel,
            value: context.formatCurrency(summary.totalExpense),
            icon: Icons.trending_down,
            color: AppColors.expense,
          ),
          _MetricData(
            label: l10n.reportNetBalanceLabel,
            value: context.formatCurrency(summary.netBalance),
            icon: Icons.account_balance_outlined,
            color: summary.netBalance >= 0 ? AppColors.income : AppColors.expense,
          ),
          _MetricData(
            label: l10n.reportTransactionCountLabel,
            value: summary.transactionCount.toString(),
            icon: Icons.receipt_long_outlined,
            color: AppColors.info,
          ),
        ],
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        final children = metrics
            .map(
              (metric) => DashboardMetricCard(
                label: metric.label,
                value: metric.value,
                icon: metric.icon,
                color: metric.color,
              ),
            )
            .toList();

        if (isWide) {
          return Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                Expanded(child: children[i]),
                if (i < children.length - 1) const SizedBox(width: AppSpacing.md),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1) const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}
