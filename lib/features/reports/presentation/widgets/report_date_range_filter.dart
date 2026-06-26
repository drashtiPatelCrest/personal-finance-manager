import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/financial_report.dart';
import '../utils/report_type_parser.dart';

class ReportDateRangeFilter extends StatelessWidget {
  const ReportDateRangeFilter({
    super.key,
    required this.selectedPreset,
    required this.onChanged,
  });

  final ReportDateRangePreset selectedPreset;
  final ValueChanged<ReportDateRangePreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ReportDateRangePreset.values.map((preset) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AppChip(
              label: context.reportDateRangeLabel(preset),
              selected: selectedPreset == preset,
              onTap: () => onChanged(preset),
            ),
          );
        }).toList(),
      ),
    );
  }
}
