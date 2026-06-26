import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../../categories/domain/constants/category_colors.dart';
import '../../../categories/domain/constants/category_icons.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_detail/transaction_detail_bloc.dart';
import '../utils/transaction_localization.dart';
import '../widgets/transaction_error_banner.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({
    super.key,
    required this.transactionId,
  });

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<TransactionDetailBloc>()
        ..add(TransactionDetailLoadRequested(transactionId)),
      child: BlocConsumer<TransactionDetailBloc, TransactionDetailState>(
        listener: (context, state) {
          if (state.deleted) {
            AppSnackBar.success(context, l10n.transactionDeleteSuccess);
            context.pop();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.transactionDetailTitle,
                variant: AppTextVariant.titleLarge,
              ),
              actions: [
                if (state.transaction != null)
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: l10n.transactionEditTitle,
                    onPressed: () => context.push(
                      RoutePaths.transactionEditPath(transactionId),
                    ),
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

  Widget _buildBody(BuildContext context, TransactionDetailState state) {
    if (state.isLoading && state.transaction == null) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.transaction == null) {
      return Column(
        children: [
          if (state.errorCode != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: TransactionErrorBanner(errorCode: state.errorCode!),
            ),
          Expanded(
            child: AppErrorState(
              onRetry: () => context.read<TransactionDetailBloc>().add(
                    TransactionDetailLoadRequested(transactionId),
                  ),
            ),
          ),
        ],
      );
    }

    final transaction = state.transaction;
    if (transaction == null) {
      return const AppLoadingIndicator();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, transaction),
          const SizedBox(height: AppSpacing.xl),
          _buildDetailRow(
            context,
            label: context.l10n.transactionCategoryLabel,
            value: transaction.category.name,
          ),
          _buildDetailRow(
            context,
            label: context.l10n.transactionTypeLabel,
            value: context.transactionTypeLabel(transaction.type),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.transactionDateLabel,
            value: DateFormat.yMMMMd().format(transaction.date),
          ),
          if (transaction.note.isNotEmpty)
            _buildDetailRow(
              context,
              label: context.l10n.transactionNoteLabel,
              value: transaction.note,
            ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: context.l10n.transactionEditTitle,
            onPressed: () => context.push(
              RoutePaths.transactionEditPath(transactionId),
            ),
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppOutlinedButton(
            label: context.l10n.transactionDeleteAction,
            onPressed: state.isDeleting
                ? null
                : () => _confirmDelete(context, transaction),
            isExpanded: true,
            isLoading: state.isDeleting,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';
    final categoryColor = CategoryColors.decode(transaction.category.colorValue);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: categoryColor.withValues(alpha: 0.15),
              child: Icon(
                CategoryIcons.resolve(transaction.category.iconCode),
                color: categoryColor,
                size: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppText(
              '$prefix${context.formatCurrency(transaction.amount)}',
              variant: AppTextVariant.headlineSmall,
              color: amountColor,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              transaction.category.name,
              variant: AppTextVariant.titleMedium,
            ),
          ],
        ),
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
      context.read<TransactionDetailBloc>().add(
            TransactionDetailDeleteRequested(transactionId),
          );
    }
  }
}
