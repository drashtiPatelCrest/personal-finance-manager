import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../../domain/entities/dashboard_snapshot.dart';

class DashboardCategoryChart extends StatelessWidget {
  const DashboardCategoryChart({
    super.key,
    required this.items,
  });

  final List<CategoryDistributionItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = items.fold<double>(0, (sum, item) => sum + item.amount);
    final isEmpty = items.isEmpty || total <= 0;

    return AppChartContainer(
      title: l10n.dashboardCategoryChartTitle,
      isEmpty: isEmpty,
      emptyMessage: l10n.dashboardChartEmptyMessage,
      wrapContent: true,
      child: isEmpty
          ? const SizedBox.shrink()
          : LayoutBuilder(
              builder: (context, constraints) {
                final useStackedLayout = constraints.maxWidth < 520;

                if (useStackedLayout) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.4,
                        child: _CategoryPieChart(
                          items: items,
                          totalLabel: context.formatCurrency(total),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _CategoryLegend(items: items, total: total),
                    ],
                  );
                }

                return SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _CategoryPieChart(
                          items: items,
                          totalLabel: context.formatCurrency(total),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: _CategoryLegend(items: items, total: total),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _CategoryPieChart extends StatelessWidget {
  const _CategoryPieChart({
    required this.items,
    required this.totalLabel,
  });

  final List<CategoryDistributionItem> items;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortestSide = constraints.biggest.shortestSide;
        final centerSpaceRadius = (shortestSide * 0.26).clamp(36.0, 58.0);
        final sectionRadius = (shortestSide * 0.22).clamp(32.0, 48.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: centerSpaceRadius,
                sections: [
                  for (final item in items)
                    PieChartSectionData(
                      value: item.amount,
                      color: Color(item.colorValue),
                      title: '',
                      radius: sectionRadius,
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: centerSpaceRadius * 0.35,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    context.l10n.transactionSummaryExpense,
                    variant: AppTextVariant.caption,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      totalLabel,
                      style: AppTextStyles.money(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  const _CategoryLegend({
    required this.items,
    required this.total,
  });

  final List<CategoryDistributionItem> items;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _LegendHeader(),
        const SizedBox(height: AppSpacing.sm),
        for (final item in items.take(5))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _CategoryLegendRow(
              color: Color(item.colorValue),
              name: item.categoryName,
              amount: context.formatCurrency(item.amount),
              percentage: total > 0 ? (item.amount / total * 100).round() : 0,
            ),
          ),
      ],
    );
  }
}

class _LegendHeader extends StatelessWidget {
  const _LegendHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              context.l10n.transactionCategoryLabel,
              variant: AppTextVariant.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 40,
            child: AppText(
              '%',
              variant: AppTextVariant.caption,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 72,
            child: AppText(
              context.l10n.transactionAmountLabel,
              variant: AppTextVariant.caption,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryLegendRow extends StatelessWidget {
  const _CategoryLegendRow({
    required this.color,
    required this.name,
    required this.amount,
    required this.percentage,
  });

  final Color color;
  final String name;
  final String amount;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppText(
            name,
            variant: AppTextVariant.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 40,
          child: AppText(
            '$percentage%',
            variant: AppTextVariant.labelMedium,
            textAlign: TextAlign.end,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 72,
          child: AppText(
            amount,
            variant: AppTextVariant.labelMedium,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
