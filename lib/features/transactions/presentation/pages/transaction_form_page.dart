import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_form/transaction_form_bloc.dart';
import '../utils/transaction_localization.dart';
import '../widgets/transaction_error_banner.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    super.key,
    this.transactionId,
    this.initialType,
  });

  final String? transactionId;
  final TransactionType? initialType;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _fieldsInitialized = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.transactionId != null;

    return BlocProvider(
      create: (_) => getIt<TransactionFormBloc>()
        ..add(
          TransactionFormLoadRequested(
            transactionId: widget.transactionId,
            initialType: widget.initialType,
          ),
        ),
      child: BlocConsumer<TransactionFormBloc, TransactionFormState>(
        listener: (context, state) {
          if (!_fieldsInitialized && state.initialAmount != null) {
            _amountController.text = state.initialAmount!.toStringAsFixed(2);
            _noteController.text = state.initialNote ?? '';
            _fieldsInitialized = true;
          }
          if (state.saved) {
            AppSnackBar.success(
              context,
              isEditing
                  ? l10n.transactionUpdateSuccess
                  : l10n.transactionCreateSuccess,
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                isEditing
                    ? l10n.transactionEditTitle
                    : l10n.transactionCreateTitle,
                variant: AppTextVariant.titleLarge,
              ),
            ),
            bodyPadding: context.horizontalPagePadding,
            body: state.isLoading && isEditing && !_fieldsInitialized
                ? const AppLoadingIndicator()
                : SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state.isFailure && state.errorCode != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.lg,
                              ),
                              child: TransactionErrorBanner(
                                errorCode: state.errorCode!,
                              ),
                            ),
                          if (!isEditing) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: AppChip(
                                    label: context.transactionTypeLabel(
                                      TransactionType.income,
                                    ),
                                    selected:
                                        state.type == TransactionType.income,
                                    onTap: () => context
                                        .read<TransactionFormBloc>()
                                        .add(
                                          const TransactionFormTypeChanged(
                                            TransactionType.income,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: AppChip(
                                    label: context.transactionTypeLabel(
                                      TransactionType.expense,
                                    ),
                                    selected:
                                        state.type == TransactionType.expense,
                                    onTap: () => context
                                        .read<TransactionFormBloc>()
                                        .add(
                                          const TransactionFormTypeChanged(
                                            TransactionType.expense,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          AppTextField(
                            controller: _amountController,
                            label: l10n.transactionAmountLabel,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _buildCategoryDropdown(context, state),
                          const SizedBox(height: AppSpacing.lg),
                          _buildDatePicker(context, state),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            controller: _noteController,
                            label: l10n.transactionNoteLabel,
                            maxLines: 3,
                            maxLength: 500,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          AppButton(
                            label: isEditing
                                ? l10n.transactionSaveAction
                                : l10n.transactionCreateAction,
                            onPressed: state.isLoading || state.categories.isEmpty
                                ? null
                                : () => _submit(context),
                            isExpanded: true,
                            isLoading: state.isLoading,
                          ),
                          if (state.categories.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: AppSpacing.md),
                              child: AppText(
                                l10n.transactionNoCategoriesMessage,
                                variant: AppTextVariant.caption,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(
    BuildContext context,
    TransactionFormState state,
  ) {
    final l10n = context.l10n;

    return AppDropdown<String?>(
      label: l10n.transactionCategoryLabel,
      hint: l10n.transactionCategoryLabel,
      value: state.selectedCategoryId,
      enabled: state.categories.isNotEmpty,
      items: state.categories
          .map(
            (category) => DropdownMenuItem<String?>(
              value: category.id,
              child: Text(category.name),
            ),
          )
          .toList(),
      onChanged: (categoryId) => context.read<TransactionFormBloc>().add(
            TransactionFormCategoryChanged(categoryId),
          ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    TransactionFormState state,
  ) {
    final l10n = context.l10n;
    final date = state.date ?? DateTime.now();
    final formattedDate = DateFormat.yMMMd().format(date);

    return AppOutlinedButton(
      label: '${l10n.transactionDateLabel}: $formattedDate',
      onPressed: () => _pickDate(context, state),
      isExpanded: true,
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    TransactionFormState state,
  ) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: state.date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && context.mounted) {
      context.read<TransactionFormBloc>().add(
            TransactionFormDateChanged(selectedDate),
          );
    }
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      AppSnackBar.error(context, context.l10n.transactionErrorAmountRequired);
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      AppSnackBar.error(context, context.l10n.transactionErrorAmountInvalid);
      return;
    }

    context.read<TransactionFormBloc>().add(
          TransactionFormSubmitted(
            amount: amount,
            note: _noteController.text,
          ),
        );
  }
}
