import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../utils/transaction_localization.dart';

class TransactionSummaryCard extends StatelessWidget {
  const TransactionSummaryCard({
    super.key,
    required this.title,
    required this.summary,
  });

  final String title;
  final Map<String, num>? summary;

  @override
  Widget build(BuildContext context) {
    final income = summary?['income'] ?? 0;
    final expense = summary?['expense'] ?? 0;
    final net = summary?['net'] ?? 0;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title, variant: AppTextVariant.titleSmall),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: context.l10n.transactionSummaryIncome,
                    value: context.formatCurrency(income),
                    color: AppColors.income,
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: context.l10n.transactionSummaryExpense,
                    value: context.formatCurrency(expense),
                    color: AppColors.expense,
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: context.l10n.transactionSummaryNet,
                    value: context.formatCurrency(net),
                    color: net >= 0 ? AppColors.income : AppColors.expense,
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

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, variant: AppTextVariant.caption),
        const SizedBox(height: AppSpacing.xs),
        AppText(value, variant: AppTextVariant.titleSmall, color: color),
      ],
    );
  }
}
