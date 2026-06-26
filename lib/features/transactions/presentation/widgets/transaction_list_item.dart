import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
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
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';
    final categoryColor = CategoryColors.decode(transaction.category.colorValue);
    final dateLabel = DateFormat.yMMMd().format(transaction.date);

    return AppListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: categoryColor.withValues(alpha: 0.15),
        child: Icon(
          CategoryIcons.resolve(transaction.category.iconCode),
          color: categoryColor,
        ),
      ),
      title: AppText(transaction.category.name, variant: AppTextVariant.titleSmall),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            '${context.transactionTypeLabel(transaction.type)} · $dateLabel',
            variant: AppTextVariant.caption,
          ),
          if (transaction.note.isNotEmpty)
            AppText(transaction.note, variant: AppTextVariant.caption),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            '$prefix${context.formatCurrency(transaction.amount)}',
            variant: AppTextVariant.titleSmall,
            color: amountColor,
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
