import 'package:flutter/material.dart';

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
  });

  final ExportDataType dataType;
  final bool isPdfLoading;
  final bool isCsvLoading;
  final VoidCallback onExportPdf;
  final VoidCallback onExportCsv;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: context.exportFormatLabel(ExportFormat.pdf),
                  onPressed: isPdfLoading ? null : onExportPdf,
                  isLoading: isPdfLoading,
                ),
                AppOutlinedButton(
                  label: context.exportFormatLabel(ExportFormat.csv),
                  onPressed: isCsvLoading ? null : onExportCsv,
                  isLoading: isCsvLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
