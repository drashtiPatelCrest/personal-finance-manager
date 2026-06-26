import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../utils/dashboard_localization.dart';

class DashboardDateRangeFilter extends StatelessWidget {
  const DashboardDateRangeFilter({
    super.key,
    required this.selectedPreset,
    required this.onChanged,
  });

  final DashboardDateRangePreset selectedPreset;
  final ValueChanged<DashboardDateRangePreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DashboardDateRangePreset.values.map((preset) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AppChip(
              label: context.dashboardDateRangeLabel(preset),
              selected: selectedPreset == preset,
              onTap: () => onChanged(preset),
            ),
          );
        }).toList(),
      ),
    );
  }
}
