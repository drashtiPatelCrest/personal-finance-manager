import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.index = 0,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AppFadeIn(
      delay: Duration(milliseconds: 50 * index),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: AppDimensions.metricIconSize,
              height: AppDimensions.metricIconSize,
              decoration: AppDecorations.iconBadge(color: color),
              child: Icon(icon, color: color, size: AppDimensions.iconSizeMd),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(label, variant: AppTextVariant.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: AppTextStyles.moneyLarge(context, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
