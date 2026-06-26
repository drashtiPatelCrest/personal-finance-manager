import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/constants/category_icons.dart';

class CategoryIconPicker extends StatelessWidget {
  const CategoryIconPicker({
    super.key,
    required this.selectedIconCode,
    required this.onIconSelected,
    required this.title,
  });

  final String selectedIconCode;
  final ValueChanged<String> onIconSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, variant: AppTextVariant.sectionHeader),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: CategoryIcons.icons.entries.map((entry) {
            final isSelected = entry.key == selectedIconCode;
            return Semantics(
              selected: isSelected,
              button: true,
              child: InkWell(
                onTap: () => onIconSelected(entry.key),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.4)
                        : null,
                  ),
                  child: Icon(entry.value),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
