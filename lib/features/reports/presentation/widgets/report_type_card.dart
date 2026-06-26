import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/financial_report.dart';
import '../utils/report_type_parser.dart';

class ReportTypeCard extends StatelessWidget {
  const ReportTypeCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  final ReportType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(_iconForType(type)),
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
            const Icon(Icons.chevron_right),
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
