import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../../domain/entities/dashboard_snapshot.dart';

class DashboardIncomeExpenseChart extends StatelessWidget {
  const DashboardIncomeExpenseChart({
    super.key,
    required this.snapshot,
  });

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brightness = Theme.of(context).brightness;
    final maxValue = [
      snapshot.totalIncome,
      snapshot.totalExpense,
    ].fold<double>(0, (max, value) => value > max ? value : max);

    return AppChartContainer(
      title: l10n.dashboardIncomeExpenseChartTitle,
      isEmpty: maxValue <= 0,
      emptyMessage: l10n.dashboardChartEmptyMessage,
      footer: Row(
        children: [
          Expanded(
            child: _LegendItem(
              color: AppColors.incomeFor(brightness),
              label: l10n.transactionSummaryIncome,
              value: context.formatCurrency(snapshot.totalIncome),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _LegendItem(
              color: AppColors.expenseFor(brightness),
              label: l10n.transactionSummaryExpense,
              value: context.formatCurrency(snapshot.totalExpense),
            ),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxValue <= 0 ? 1 : maxValue * 1.2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue <= 0 ? 1 : maxValue / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.35),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final label = switch (value.toInt()) {
                    0 => l10n.transactionSummaryIncome,
                    1 => l10n.transactionSummaryExpense,
                    _ => '',
                  };
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: AppText(label, variant: AppTextVariant.caption),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: snapshot.totalIncome,
                  color: AppColors.incomeFor(brightness),
                  width: 48,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.borderRadiusSm),
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: snapshot.totalExpense,
                  color: AppColors.expenseFor(brightness),
                  width: 48,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.borderRadiusSm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppText(label, variant: AppTextVariant.caption),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(value, variant: AppTextVariant.titleSmall, color: color),
        ],
      ),
    );
  }
}
