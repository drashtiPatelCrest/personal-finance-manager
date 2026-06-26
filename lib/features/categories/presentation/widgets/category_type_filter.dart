import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/category.dart';
import '../utils/category_localization.dart';

class CategoryTypeFilter extends StatelessWidget {
  const CategoryTypeFilter({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final CategoryType? selectedType;
  final ValueChanged<CategoryType?> onChanged;

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
            label: context.categoryTypeLabel(CategoryType.income),
            selected: selectedType == CategoryType.income,
            onTap: () => onChanged(CategoryType.income),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: context.categoryTypeLabel(CategoryType.expense),
            selected: selectedType == CategoryType.expense,
            onTap: () => onChanged(CategoryType.expense),
          ),
        ],
      ),
    );
  }
}
