import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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

    return AppFadeIn(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title, variant: AppTextVariant.titleSmall),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: context.l10n.transactionSummaryIncome,
                    value: context.formatCurrency(income),
                    accentColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryMetric(
                    label: context.l10n.transactionSummaryExpense,
                    value: context.formatCurrency(expense),
                    accentColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SummaryMetric(
                    label: context.l10n.transactionSummaryNet,
                    value: context.formatCurrency(net),
                    accentColor: net >= 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
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
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.metricAccent(accentColor: accentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, variant: AppTextVariant.caption),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.money(context, color: accentColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
