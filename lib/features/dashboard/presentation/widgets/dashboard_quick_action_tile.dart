import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

class DashboardQuickActionTile extends StatelessWidget {
  const DashboardQuickActionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = color ?? colorScheme.primary;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDimensions.metricIconSize,
            height: AppDimensions.metricIconSize,
            decoration: AppDecorations.iconBadge(color: accentColor),
            child: Icon(icon, color: accentColor, size: AppDimensions.iconSizeMd),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            label,
            variant: AppTextVariant.labelMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
