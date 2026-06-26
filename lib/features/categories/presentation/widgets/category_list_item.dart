import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/constants/category_colors.dart';
import '../../domain/constants/category_icons.dart';
import '../../domain/entities/category.dart';
import '../utils/category_localization.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.category,
    required this.onTap,
    required this.onDelete,
  });

  final Category category;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = CategoryColors.decode(category.colorValue);

    return AppListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          CategoryIcons.resolve(category.iconCode),
          color: color,
        ),
      ),
      title: AppText(category.name, variant: AppTextVariant.titleSmall),
      subtitle: AppText(
        context.categoryTypeLabel(category.type),
        variant: AppTextVariant.caption,
      ),
      trailing: AppIconButton(
        icon: Icons.delete_outline,
        tooltip: context.l10n.categoryDeleteAction,
        onPressed: onDelete,
      ),
    );
  }
}
