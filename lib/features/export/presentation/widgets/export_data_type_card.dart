import 'package:flutter/material.dart';

import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/repository/export_repository.dart';
import '../utils/export_context_extensions.dart';

class ExportDataTypeCard extends StatelessWidget {
  const ExportDataTypeCard({
    super.key,
    required this.dataType,
    required this.isPdfLoading,
    required this.isCsvLoading,
    required this.onExportPdf,
    required this.onExportCsv,
    this.index = 0,
  });

  final ExportDataType dataType;
  final bool isPdfLoading;
  final bool isCsvLoading;
  final VoidCallback onExportPdf;
  final VoidCallback onExportCsv;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppFadeIn(
      delay: Duration(milliseconds: 60 * index),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: AppDimensions.metricIconSize,
                  height: AppDimensions.metricIconSize,
                  decoration:
                      AppDecorations.iconBadge(color: colorScheme.primary),
                  child: Icon(
                    _iconForType(dataType),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.exportDataTypeLabel(dataType),
                        variant: AppTextVariant.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        context.exportDataTypeDescription(dataType),
                        variant: AppTextVariant.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: context.exportFormatLabel(ExportFormat.pdf),
                  onPressed: isPdfLoading ? null : onExportPdf,
                  isLoading: isPdfLoading,
                  icon: Icons.picture_as_pdf_outlined,
                ),
                AppOutlinedButton(
                  label: context.exportFormatLabel(ExportFormat.csv),
                  onPressed: isCsvLoading ? null : onExportCsv,
                  isLoading: isCsvLoading,
                  icon: Icons.table_chart_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(ExportDataType dataType) {
    return switch (dataType) {
      ExportDataType.transactions => Icons.receipt_long_outlined,
      ExportDataType.budgets => Icons.account_balance_wallet_outlined,
      ExportDataType.goals => Icons.savings_outlined,
      ExportDataType.reports => Icons.assessment_outlined,
    };
  }
}
