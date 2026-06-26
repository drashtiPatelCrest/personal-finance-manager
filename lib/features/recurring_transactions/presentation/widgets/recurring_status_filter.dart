import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

class RecurringStatusFilter extends StatelessWidget {
  const RecurringStatusFilter({
    super.key,
    required this.selectedPaused,
    required this.onChanged,
  });

  final bool? selectedPaused;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AppChip(
            label: l10n.recurringFilterAll,
            selected: selectedPaused == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: l10n.recurringStatusActive,
            selected: selectedPaused == false,
            onTap: () => onChanged(false),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppChip(
            label: l10n.recurringStatusPaused,
            selected: selectedPaused == true,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}
