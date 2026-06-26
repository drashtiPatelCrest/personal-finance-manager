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
import '../../domain/entities/budget.dart';
import '../bloc/budget_detail/budget_detail_bloc.dart';
import '../utils/budget_localization.dart';
import '../widgets/budget_error_banner.dart';
import '../widgets/budget_progress_card.dart';

class BudgetDetailPage extends StatelessWidget {
  const BudgetDetailPage({
    super.key,
    required this.budgetId,
  });

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<BudgetDetailBloc>()
        ..add(BudgetDetailLoadRequested(budgetId)),
      child: BlocConsumer<BudgetDetailBloc, BudgetDetailState>(
        listener: (context, state) {
          if (state.deleted) {
            AppSnackBar.success(context, l10n.budgetDeleteSuccess);
            context.pop();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.budgetDetailTitle,
                variant: AppTextVariant.titleLarge,
              ),
              actions: [
                if (state.usage != null)
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: l10n.budgetEditTitle,
                    onPressed: () async {
                      await context.push(
                        RoutePaths.budgetEditPath(budgetId),
                      );
                      if (context.mounted) {
                        context.read<BudgetDetailBloc>().add(
                              BudgetDetailLoadRequested(budgetId),
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

  Widget _buildBody(BuildContext context, BudgetDetailState state) {
    if (state.isLoading && state.usage == null) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.usage == null) {
      return Column(
        children: [
          if (state.errorCode != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: BudgetErrorBanner(errorCode: state.errorCode!),
            ),
          Expanded(
            child: AppErrorState(
              onRetry: () => context.read<BudgetDetailBloc>().add(
                    BudgetDetailLoadRequested(budgetId),
                  ),
            ),
          ),
        ],
      );
    }

    final usage = state.usage;
    if (usage == null) {
      return const AppLoadingIndicator();
    }

    final budget = usage.budget;
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
                  AppText(budget.name, variant: AppTextVariant.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    context.budgetTypeLabel(budget.type),
                    variant: AppTextVariant.caption,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BudgetProgressCard(usage: usage),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildDetailRow(
            context,
            label: context.l10n.budgetLimitLabel,
            value: context.formatBudgetCurrency(budget.amount),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.budgetSpentLabel,
            value: context.formatBudgetCurrency(usage.spentAmount),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.budgetRemainingLabel,
            value: context.formatBudgetCurrency(usage.remainingAmount),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.budgetPeriodLabel,
            value:
                '${dateFormat.format(budget.startDate)} - ${dateFormat.format(budget.endDate)}',
          ),
          if (budget.type == BudgetType.category && usage.categoryName != null)
            _buildDetailRow(
              context,
              label: context.l10n.budgetCategoryLabel,
              value: usage.categoryName!,
            ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: context.l10n.budgetEditTitle,
            onPressed: () async {
              await context.push(RoutePaths.budgetEditPath(budgetId));
              if (context.mounted) {
                context.read<BudgetDetailBloc>().add(
                      BudgetDetailLoadRequested(budgetId),
                    );
              }
            },
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppOutlinedButton(
            label: context.l10n.budgetDeleteAction,
            onPressed: state.isDeleting
                ? null
                : () => _confirmDelete(context, budget),
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

  Future<void> _confirmDelete(BuildContext context, Budget budget) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.budgetDeleteConfirmTitle,
      message: l10n.budgetDeleteConfirmMessage(budget.name),
      confirmLabel: l10n.budgetDeleteAction,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<BudgetDetailBloc>().add(
            BudgetDetailDeleteRequested(budgetId),
          );
    }
  }
}
