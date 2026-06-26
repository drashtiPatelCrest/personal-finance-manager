import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/transaction.dart';
import '../utils/transaction_localization.dart';

class TransactionTypeFilter extends StatelessWidget {
  const TransactionTypeFilter({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final TransactionType? selectedType;
  final ValueChanged<TransactionType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AppChip(
            label: l10n.categoryFilterAll,
            selected: selectedType == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: context.transactionTypeLabel(TransactionType.income),
            selected: selectedType == TransactionType.income,
            onTap: () => onChanged(TransactionType.income),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: context.transactionTypeLabel(TransactionType.expense),
            selected: selectedType == TransactionType.expense,
            onTap: () => onChanged(TransactionType.expense),
          ),
        ],
      ),
    );
  }
}
