import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/constants/category_colors.dart';

class CategoryColorPicker extends StatelessWidget {
  const CategoryColorPicker({
    super.key,
    required this.selectedColorValue,
    required this.onColorSelected,
    required this.title,
  });

  final int selectedColorValue;
  final ValueChanged<int> onColorSelected;
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
          children: CategoryColors.palette.map((color) {
            final colorValue = CategoryColors.encode(color);
            final isSelected = colorValue == selectedColorValue;
            return Semantics(
              selected: isSelected,
              button: true,
              child: InkWell(
                onTap: () => onColorSelected(colorValue),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
