import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../utils/recurring_localization.dart';

class RecurringFrequencySelector extends StatelessWidget {
  const RecurringFrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onChanged,
  });

  final RecurrenceFrequency selectedFrequency;
  final ValueChanged<RecurrenceFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: RecurrenceFrequency.values.map((frequency) {
        return AppChip(
          label: context.recurrenceFrequencyLabel(frequency),
          selected: selectedFrequency == frequency,
          onTap: () => onChanged(frequency),
        );
      }).toList(),
    );
  }
}
