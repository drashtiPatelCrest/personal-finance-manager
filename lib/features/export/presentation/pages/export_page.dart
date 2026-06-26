import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/export_result.dart';
import '../../domain/repository/export_repository.dart';
import '../bloc/export/export_bloc.dart';
import '../utils/export_context_extensions.dart';
import '../utils/export_localization.dart';
import '../widgets/export_data_type_card.dart';
import '../widgets/export_date_range_filter.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<ExportBloc>()..add(const ExportStarted()),
      child: BlocConsumer<ExportBloc, ExportState>(
        listenWhen: (previous, current) =>
            (current.errorCode != null &&
                previous.errorNonce != current.errorNonce) ||
            previous.successNonce != current.successNonce,
        listener: (context, state) {
          if (state.errorCode != null) {
            AppSnackBar.error(
              context,
              context.exportErrorMessage(state.errorCode!),
            );
            return;
          }

          final result = state.lastResult;
          if (result != null) {
            AppSnackBar.success(
              context,
              l10n.exportSuccessMessage(result.fileName),
            );
            _showShareDialog(context, result);
          }
        },
        builder: (context, state) {
          final labels = ExportLocalizationBundle.fromL10n(l10n);

          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(l10n.exportTitle, variant: AppTextVariant.titleLarge),
            ),
            bodyPadding: context.horizontalPagePadding,
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              children: [
                AppText(
                  l10n.exportDescription,
                  variant: AppTextVariant.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppSwitch(
                          label: l10n.exportUseDateFilterLabel,
                          value: state.useDateFilter,
                          onChanged: (enabled) => context.read<ExportBloc>().add(
                                ExportDateFilterToggled(enabled),
                              ),
                        ),
                        if (state.useDateFilter) ...[
                          const SizedBox(height: AppSpacing.md),
                          ExportDateRangeFilter(
                            selectedPreset: state.dateRangePreset,
                            onChanged: (preset) => context.read<ExportBloc>().add(
                                  ExportDateRangeChanged(preset),
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...ExportDataType.values.indexed.map((entry) {
                  final index = entry.$1;
                  final dataType = entry.$2;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ExportDataTypeCard(
                      index: index,
                      dataType: dataType,
                      isPdfLoading: state.isExporting(dataType, ExportFormat.pdf),
                      isCsvLoading: state.isExporting(dataType, ExportFormat.csv),
                      onExportPdf: () => context.read<ExportBloc>().add(
                            ExportRequested(
                              dataType: dataType,
                              format: ExportFormat.pdf,
                              labels: labels,
                            ),
                          ),
                      onExportCsv: () => context.read<ExportBloc>().add(
                            ExportRequested(
                              dataType: dataType,
                              format: ExportFormat.csv,
                              labels: labels,
                            ),
                          ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showShareDialog(
    BuildContext context,
    ExportResult result,
  ) async {
    final l10n = context.l10n;
    final shouldShare = await AppConfirmationDialog.show(
      context: context,
      title: l10n.exportShareTitle,
      message: l10n.exportShareMessage,
      confirmLabel: l10n.exportShareAction,
      cancelLabel: l10n.exportShareDismissAction,
    );

    if (shouldShare == true && context.mounted) {
      context.read<ExportBloc>().add(
            ExportShareRequested(
              filePath: result.filePath,
              format: result.format,
              dataType: result.dataType,
            ),
          );
    }
  }
}
