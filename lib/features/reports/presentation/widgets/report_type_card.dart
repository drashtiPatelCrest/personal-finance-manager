import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/financial_report.dart';
import '../utils/report_type_parser.dart';

class ReportTypeCard extends StatelessWidget {
  const ReportTypeCard({
    super.key,
    required this.type,
    required this.onTap,
    this.index = 0,
  });

  final ReportType type;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _iconForType(type);

    return AppFadeIn(
      delay: Duration(milliseconds: 60 * index),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: AppDimensions.metricIconSize,
              height: AppDimensions.metricIconSize,
              decoration: AppDecorations.iconBadge(color: colorScheme.primary),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    context.reportTypeLabel(type),
                    variant: AppTextVariant.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    context.reportTypeDescription(type),
                    variant: AppTextVariant.caption,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(ReportType type) {
    return switch (type) {
      ReportType.monthly => Icons.calendar_month_outlined,
      ReportType.yearly => Icons.date_range_outlined,
      ReportType.category => Icons.pie_chart_outline,
      ReportType.budget => Icons.account_balance_wallet_outlined,
      ReportType.goal => Icons.flag_outlined,
    };
  }
}
