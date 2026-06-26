import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_list/budget_list_bloc.dart';
import '../utils/budget_localization.dart';
import '../widgets/budget_list_item.dart';

class BudgetListPage extends StatelessWidget {
  const BudgetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<BudgetListBloc>()..add(const BudgetListStarted()),
      child: BlocConsumer<BudgetListBloc, BudgetListState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.budgetErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.budgetListTitle,
                variant: AppTextVariant.titleLarge,
              ),
            ),
            floatingActionButton:
                context.isDesktop ? null : _buildFab(context),
            bodyPadding: context.horizontalPagePadding,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                AppSearchField(
                  placeholder: l10n.budgetSearchPlaceholder,
                  onChanged: (query) => context.read<BudgetListBloc>().add(
                        BudgetListSearchChanged(query),
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (context.isDesktop)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildFab(context),
                    ),
                  ),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openCreateMenu(context),
      icon: const Icon(Icons.add),
      label: Text(context.l10n.budgetAddAction),
    );
  }

  Widget _buildBody(BuildContext context, BudgetListState state) {
    if (state.isLoading && state.budgets.isEmpty) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.budgets.isEmpty) {
      return AppErrorState(
        onRetry: () => context.read<BudgetListBloc>().add(
              const BudgetListStarted(),
            ),
      );
    }

    if (state.budgets.isEmpty) {
      return AppEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: context.l10n.budgetEmptyTitle,
        message: context.l10n.budgetEmptyMessage,
        action: AppButton(
          label: context.l10n.budgetAddAction,
          onPressed: () => _openCreateMenu(context),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.budgets.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final budget = state.budgets[index];
        return BudgetListItem(
          budget: budget,
          usage: state.usages[budget.id],
          onTap: () => context.push(RoutePaths.budgetDetailPath(budget.id)),
          onDelete: () => _confirmDelete(context, budget),
        );
      },
    );
  }

  Future<void> _openCreateMenu(BuildContext context) async {
    final l10n = context.l10n;
    await AppBottomSheet.show<void>(
      context: context,
      semanticsLabel: l10n.budgetAddAction,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(l10n.budgetAddAction, variant: AppTextVariant.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.budgetCreateOverallAction,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(RoutePaths.budgetAddPath(type: 'overall'));
              },
              isExpanded: true,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.budgetCreateCategoryAction,
              variant: AppButtonVariant.tonal,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(RoutePaths.budgetAddPath(type: 'category'));
              },
              isExpanded: true,
            ),
          ],
        ),
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
      context.read<BudgetListBloc>().add(
            BudgetListDeleteRequested(budget.id),
          );
    }
  }
}
