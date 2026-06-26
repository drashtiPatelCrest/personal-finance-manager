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
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_list/transaction_list_bloc.dart';
import '../utils/transaction_localization.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/transaction_summary_card.dart';
import '../widgets/transaction_type_filter.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) =>
          getIt<TransactionListBloc>()..add(const TransactionListStarted()),
      child: BlocConsumer<TransactionListBloc, TransactionListState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.transactionErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.transactionListTitle,
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
                TransactionSummaryCard(
                  title: l10n.transactionDailySummaryTitle,
                  summary: state.dailySummary,
                ),
                const SizedBox(height: AppSpacing.md),
                TransactionSummaryCard(
                  title: l10n.transactionMonthlySummaryTitle,
                  summary: state.monthlySummary,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppSearchField(
                  placeholder: l10n.transactionSearchPlaceholder,
                  onChanged: (query) => context.read<TransactionListBloc>().add(
                        TransactionListSearchChanged(query),
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TransactionTypeFilter(
                  selectedType: state.selectedType,
                  onChanged: (type) => context.read<TransactionListBloc>().add(
                        TransactionListTypeFilterChanged(type),
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildCategoryFilter(context, state),
                const SizedBox(height: AppSpacing.md),
                _buildDateRangeFilter(context, state),
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

  Widget _buildCategoryFilter(
    BuildContext context,
    TransactionListState state,
  ) {
    final l10n = context.l10n;
    final categories = state.filteredCategories;

    return AppDropdown<String?>(
      label: l10n.transactionCategoryFilterLabel,
      hint: l10n.categoryFilterAll,
      value: state.selectedCategoryId,
      items: [
        DropdownMenuItem<String?>(
          value: null,
          child: Text(l10n.categoryFilterAll),
        ),
        ...categories.map(
          (category) => DropdownMenuItem<String?>(
            value: category.id,
            child: Text(category.name),
          ),
        ),
      ],
      onChanged: (categoryId) => context.read<TransactionListBloc>().add(
            TransactionListCategoryFilterChanged(categoryId),
          ),
    );
  }

  Widget _buildDateRangeFilter(
    BuildContext context,
    TransactionListState state,
  ) {
    final l10n = context.l10n;
    final dateFormat = DateFormat.yMMMd();
    final hasRange = state.startDate != null && state.endDate != null;
    final rangeLabel = hasRange
        ? '${dateFormat.format(state.startDate!)} - ${dateFormat.format(state.endDate!)}'
        : l10n.transactionDateRangeLabel;

    return Row(
      children: [
        Expanded(
          child: AppOutlinedButton(
            label: rangeLabel,
            onPressed: () => _pickDateRange(context, state),
            isExpanded: true,
          ),
        ),
        if (hasRange) ...[
          const SizedBox(width: AppSpacing.sm),
          AppIconButton(
            icon: Icons.clear,
            tooltip: l10n.transactionClearDateRangeAction,
            onPressed: () => context.read<TransactionListBloc>().add(
                  const TransactionListDateRangeCleared(),
                ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    TransactionListState state,
  ) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: state.startDate != null && state.endDate != null
          ? DateTimeRange(start: state.startDate!, end: state.endDate!)
          : DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 30)),
              end: DateTime.now(),
            ),
    );

    if (range != null && context.mounted) {
      context.read<TransactionListBloc>().add(
            TransactionListDateRangeChanged(
              startDate: range.start,
              endDate: range.end,
            ),
          );
    }
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openCreateMenu(context),
      icon: const Icon(Icons.add),
      label: Text(context.l10n.transactionAddAction),
    );
  }

  Widget _buildBody(BuildContext context, TransactionListState state) {
    if (state.isLoading && state.transactions.isEmpty) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.transactions.isEmpty) {
      return AppErrorState(
        onRetry: () => context.read<TransactionListBloc>().add(
              const TransactionListStarted(),
            ),
      );
    }

    if (state.transactions.isEmpty) {
      return AppEmptyState(
        icon: Icons.receipt_long_outlined,
        title: context.l10n.transactionEmptyTitle,
        message: context.l10n.transactionEmptyMessage,
        action: AppButton(
          label: context.l10n.transactionAddAction,
          onPressed: () => _openCreateMenu(context),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.transactions.length,
      separatorBuilder: (_, _) => const AppDivider(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final transaction = state.transactions[index];
        return TransactionListItem(
          transaction: transaction,
          onTap: () => context.push(
            RoutePaths.transactionDetailPath(transaction.id),
          ),
          onDelete: () => _confirmDelete(context, transaction),
        );
      },
    );
  }

  Future<void> _openCreateMenu(BuildContext context) async {
    final l10n = context.l10n;
    await AppBottomSheet.show<void>(
      context: context,
      semanticsLabel: l10n.transactionAddAction,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(l10n.transactionAddAction, variant: AppTextVariant.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.transactionCreateIncomeAction,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(
                  RoutePaths.transactionAddPath(type: 'income'),
                );
              },
              isExpanded: true,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.transactionCreateExpenseAction,
              variant: AppButtonVariant.tonal,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(
                  RoutePaths.transactionAddPath(type: 'expense'),
                );
              },
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Transaction transaction,
  ) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.transactionDeleteConfirmTitle,
      message: l10n.transactionDeleteConfirmMessage(
        context.formatCurrency(transaction.amount),
      ),
      confirmLabel: l10n.transactionDeleteAction,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<TransactionListBloc>().add(
            TransactionListDeleteRequested(transaction.id),
          );
    }
  }
}
