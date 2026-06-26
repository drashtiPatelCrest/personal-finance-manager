import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/dashboard_snapshot.dart';

class DashboardMonthlyTrendChart extends StatelessWidget {
  const DashboardMonthlyTrendChart({
    super.key,
    required this.points,
  });

  final List<MonthlyTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brightness = Theme.of(context).brightness;
    final monthFormat = DateFormat.MMM();

    if (points.isEmpty) {
      return AppChartContainer(
        title: l10n.dashboardMonthlyTrendChartTitle,
        isEmpty: true,
        emptyMessage: l10n.dashboardChartEmptyMessage,
        child: const SizedBox.shrink(),
      );
    }

    final maxValue = points
        .expand((point) => [point.income, point.expense])
        .fold<double>(0, (max, value) => value > max ? value : max);

    return AppChartContainer(
      title: l10n.dashboardMonthlyTrendChartTitle,
      footer: Row(
        children: [
          _TrendLegend(
            color: AppColors.incomeFor(brightness),
            label: l10n.transactionSummaryIncome,
          ),
          const SizedBox(width: AppSpacing.lg),
          _TrendLegend(
            color: AppColors.expenseFor(brightness),
            label: l10n.transactionSummaryExpense,
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
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
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  final point = points[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: AppText(
                      monthFormat.format(DateTime(point.year, point.month)),
                      variant: AppTextVariant.caption,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].income),
              ],
              color: AppColors.incomeFor(brightness),
              barWidth: 3,
              isCurved: true,
              curveSmoothness: 0.25,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.incomeFor(brightness).withValues(alpha: 0.12),
              ),
            ),
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].expense),
              ],
              color: AppColors.expenseFor(brightness),
              barWidth: 3,
              isCurved: true,
              curveSmoothness: 0.25,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.expenseFor(brightness).withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendLegend extends StatelessWidget {
  const _TrendLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppText(label, variant: AppTextVariant.caption),
      ],
    );
  }
}
