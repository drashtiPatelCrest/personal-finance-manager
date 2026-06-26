import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../categories/domain/constants/category_colors.dart';
import '../../../categories/domain/constants/category_icons.dart';
import '../../domain/entities/transaction.dart';
import '../utils/transaction_localization.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  final Transaction transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome
        ? AppColors.incomeFor(brightness)
        : AppColors.expenseFor(brightness);
    final prefix = isIncome ? '+' : '-';
    final categoryColor = CategoryColors.decode(transaction.category.colorValue);
    final dateLabel = DateFormat.yMMMd().format(transaction.date);

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CategoryIcons.resolve(transaction.category.iconCode),
              color: categoryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  transaction.category.name,
                  variant: AppTextVariant.titleSmall,
                  maxLines: 1,
                ),
                AppText(
                  '${context.transactionTypeLabel(transaction.type)} · $dateLabel',
                  variant: AppTextVariant.caption,
                  maxLines: 1,
                ),
                if (transaction.note.isNotEmpty)
                  AppText(
                    transaction.note,
                    variant: AppTextVariant.caption,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$prefix${context.formatCurrency(transaction.amount)}',
            style: AppTextStyles.money(context, color: amountColor),
          ),
          AppIconButton(
            icon: Icons.delete_outline,
            tooltip: context.l10n.transactionDeleteAction,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
