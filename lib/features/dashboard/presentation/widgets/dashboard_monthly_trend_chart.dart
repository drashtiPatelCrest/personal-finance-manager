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
    final monthFormat = DateFormat.MMM();

    if (points.isEmpty) {
      return AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                l10n.dashboardMonthlyTrendChartTitle,
                variant: AppTextVariant.titleSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                l10n.dashboardChartEmptyMessage,
                variant: AppTextVariant.caption,
              ),
            ],
          ),
        ),
      );
    }

    final maxValue = points
        .expand((point) => [point.income, point.expense])
        .fold<double>(0, (max, value) => value > max ? value : max);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              l10n.dashboardMonthlyTrendChartTitle,
              variant: AppTextVariant.titleSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  maxY: maxValue <= 0 ? 1 : maxValue * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxValue <= 0 ? 1 : maxValue / 4,
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
                            padding: const EdgeInsets.only(top: 8),
                            child: AppText(
                              monthFormat.format(
                                DateTime(point.year, point.month),
                              ),
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
                      color: AppColors.income,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < points.length; i++)
                          FlSpot(i.toDouble(), points[i].expense),
                      ],
                      color: AppColors.expense,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
