import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
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
    final maxValue = [
      snapshot.totalIncome,
      snapshot.totalExpense,
    ].fold<double>(0, (max, value) => value > max ? value : max);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              l10n.dashboardIncomeExpenseChartTitle,
              variant: AppTextVariant.titleSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 200,
              child: maxValue <= 0
                  ? Center(
                      child: AppText(
                        l10n.dashboardChartEmptyMessage,
                        variant: AppTextVariant.caption,
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        maxY: maxValue * 1.2,
                        gridData: const FlGridData(show: false),
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
                                  padding: const EdgeInsets.only(top: 8),
                                  child: AppText(
                                    label,
                                    variant: AppTextVariant.caption,
                                  ),
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
                                color: AppColors.income,
                                width: 40,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: snapshot.totalExpense,
                                color: AppColors.expense,
                                width: 40,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LegendItem(
                  color: AppColors.income,
                  label: context.formatCurrency(snapshot.totalIncome),
                ),
                _LegendItem(
                  color: AppColors.expense,
                  label: context.formatCurrency(snapshot.totalExpense),
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
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
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
