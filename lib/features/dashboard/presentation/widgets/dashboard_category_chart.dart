import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
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

    if (items.isEmpty || total <= 0) {
      return AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                l10n.dashboardCategoryChartTitle,
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

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              l10n.dashboardCategoryChartTitle,
              variant: AppTextVariant.titleSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: [
                    for (final item in items)
                      PieChartSectionData(
                        value: item.amount,
                        color: Color(item.colorValue),
                        title: '',
                        radius: 48,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...items.take(5).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(item.colorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppText(
                            item.categoryName,
                            variant: AppTextVariant.caption,
                          ),
                        ),
                        AppText(
                          context.formatCurrency(item.amount),
                          variant: AppTextVariant.caption,
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
