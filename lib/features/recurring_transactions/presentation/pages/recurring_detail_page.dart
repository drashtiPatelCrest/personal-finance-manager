import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../bloc/recurring_detail/recurring_detail_bloc.dart';
import '../utils/recurring_localization.dart';
import '../widgets/recurring_error_banner.dart';

class RecurringDetailPage extends StatelessWidget {
  const RecurringDetailPage({super.key, required this.recurringId});

  final String recurringId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<RecurringDetailBloc>()
        ..add(RecurringDetailLoadRequested(recurringId)),
      child: BlocConsumer<RecurringDetailBloc, RecurringDetailState>(
        listenWhen: (previous, current) =>
            current.deleted ||
            current.statusChanged ||
            (current.errorCode != null &&
                previous.errorNonce != current.errorNonce),
        listener: (context, state) {
          if (state.deleted) {
            AppSnackBar.success(context, l10n.recurringDeleteSuccess);
            context.pop();
          }
          if (state.statusChanged && state.recurring != null) {
            AppSnackBar.success(
              context,
              state.recurring!.isPaused
                  ? l10n.recurringPauseSuccess
                  : l10n.recurringResumeSuccess,
            );
          }
          if (state.errorCode != null &&
              !state.isDeleting &&
              !state.isUpdatingStatus) {
            AppSnackBar.error(
              context,
              context.recurringErrorMessage(state.errorCode!),
            );
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.recurringDetailTitle,
                variant: AppTextVariant.titleLarge,
              ),
              actions: [
                if (state.recurring != null)
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: l10n.recurringEditTitle,
                    onPressed: () async {
                      await context.push(
                        RoutePaths.recurringEditPath(recurringId),
                      );
                      if (context.mounted) {
                        context.read<RecurringDetailBloc>().add(
                              RecurringDetailLoadRequested(recurringId),
                            );
                      }
                    },
                  ),
              ],
            ),
            bodyPadding: context.horizontalPagePadding,
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, RecurringDetailState state) {
    if (state.isLoading && state.recurring == null) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.recurring == null) {
      return Column(
        children: [
          if (state.errorCode != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: RecurringErrorBanner(errorCode: state.errorCode!),
            ),
          Expanded(
            child: AppErrorState(
              onRetry: () => context.read<RecurringDetailBloc>().add(
                    RecurringDetailLoadRequested(recurringId),
                  ),
            ),
          ),
        ],
      );
    }

    final recurring = state.recurring;
    if (recurring == null) {
      return const AppLoadingIndicator();
    }

    final dateFormat = DateFormat.yMMMMd();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    recurring.category.name,
                    variant: AppTextVariant.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    context.recurringStatusLabel(recurring.isPaused),
                    variant: AppTextVariant.caption,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppText(
                    context.formatRecurringCurrency(recurring.amount),
                    variant: AppTextVariant.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildDetailRow(
            context,
            label: context.l10n.recurringFrequencyLabel,
            value: context.recurrenceFrequencyLabel(recurring.frequency),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.recurringNextExecutionLabel,
            value: dateFormat.format(recurring.nextExecutionDate),
          ),
          if (recurring.note.isNotEmpty)
            _buildDetailRow(
              context,
              label: context.l10n.recurringNoteLabel,
              value: recurring.note,
            ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: context.l10n.recurringEditTitle,
            onPressed: () async {
              await context.push(RoutePaths.recurringEditPath(recurringId));
              if (context.mounted) {
                context.read<RecurringDetailBloc>().add(
                      RecurringDetailLoadRequested(recurringId),
                    );
              }
            },
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.md),
          if (recurring.isPaused)
            AppButton(
              label: context.l10n.recurringResumeAction,
              onPressed: state.isUpdatingStatus
                  ? null
                  : () => context.read<RecurringDetailBloc>().add(
                        RecurringDetailResumeRequested(recurringId),
                      ),
              isExpanded: true,
              isLoading: state.isUpdatingStatus,
            )
          else
            AppOutlinedButton(
              label: context.l10n.recurringPauseAction,
              onPressed: state.isUpdatingStatus
                  ? null
                  : () => context.read<RecurringDetailBloc>().add(
                        RecurringDetailPauseRequested(recurringId),
                      ),
              isExpanded: true,
              isLoading: state.isUpdatingStatus,
            ),
          const SizedBox(height: AppSpacing.md),
          AppOutlinedButton(
            label: context.l10n.recurringDeleteAction,
            onPressed: state.isDeleting
                ? null
                : () => _confirmDelete(context, recurring),
            isExpanded: true,
            isLoading: state.isDeleting,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, variant: AppTextVariant.caption),
          const SizedBox(height: AppSpacing.xs),
          AppText(value, variant: AppTextVariant.bodyLarge),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    RecurringTransaction recurring,
  ) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.recurringDeleteConfirmTitle,
      message: l10n.recurringDeleteConfirmMessage(recurring.category.name),
      confirmLabel: l10n.recurringDeleteAction,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<RecurringDetailBloc>().add(
            RecurringDetailDeleteRequested(recurringId),
          );
    }
  }
}
