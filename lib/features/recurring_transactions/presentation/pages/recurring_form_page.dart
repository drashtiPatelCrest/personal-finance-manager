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
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../bloc/recurring_form/recurring_form_bloc.dart';
import '../widgets/recurring_error_banner.dart';
import '../widgets/recurring_frequency_selector.dart';

class RecurringFormPage extends StatefulWidget {
  const RecurringFormPage({
    super.key,
    this.recurringId,
    this.initialType,
  });

  final String? recurringId;
  final TransactionType? initialType;

  @override
  State<RecurringFormPage> createState() => _RecurringFormPageState();
}

class _RecurringFormPageState extends State<RecurringFormPage> {
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
    final isEditing = widget.recurringId != null;

    return BlocProvider(
      create: (_) => getIt<RecurringFormBloc>()
        ..add(
          RecurringFormLoadRequested(
            recurringId: widget.recurringId,
            initialType: widget.initialType,
          ),
        ),
      child: BlocConsumer<RecurringFormBloc, RecurringFormState>(
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
                  ? l10n.recurringUpdateSuccess
                  : l10n.recurringCreateSuccess,
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
                    ? l10n.recurringEditTitle
                    : l10n.recurringCreateTitle,
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
                              child: RecurringErrorBanner(
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
                                        .read<RecurringFormBloc>()
                                        .add(
                                          const RecurringFormTypeChanged(
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
                                        .read<RecurringFormBloc>()
                                        .add(
                                          const RecurringFormTypeChanged(
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
                            label: l10n.recurringAmountLabel,
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
                          AppText(
                            l10n.recurringFrequencyLabel,
                            variant: AppTextVariant.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          RecurringFrequencySelector(
                            selectedFrequency: state.frequency,
                            onChanged: (frequency) => context
                                .read<RecurringFormBloc>()
                                .add(RecurringFormFrequencyChanged(frequency)),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _buildNextExecutionPicker(context, state),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            controller: _noteController,
                            label: l10n.recurringNoteLabel,
                            maxLines: 3,
                            maxLength: 500,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          AppButton(
                            label: isEditing
                                ? l10n.recurringSaveAction
                                : l10n.recurringCreateAction,
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
                                l10n.recurringNoCategoriesMessage,
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
    RecurringFormState state,
  ) {
    final l10n = context.l10n;

    return AppDropdown<String?>(
      label: l10n.recurringCategoryLabel,
      hint: l10n.recurringCategoryLabel,
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
      onChanged: (categoryId) {
        if (categoryId == null) {
          return;
        }
        context.read<RecurringFormBloc>().add(
              RecurringFormCategoryChanged(categoryId),
            );
      },
    );
  }

  Widget _buildNextExecutionPicker(
    BuildContext context,
    RecurringFormState state,
  ) {
    final l10n = context.l10n;
    final date = state.nextExecutionDate ?? DateTime.now();
    final formattedDate = DateFormat.yMMMd().format(date);

    return AppOutlinedButton(
      label: '${l10n.recurringNextExecutionLabel}: $formattedDate',
      onPressed: () => _pickNextExecution(context, state),
      isExpanded: true,
    );
  }

  Future<void> _pickNextExecution(
    BuildContext context,
    RecurringFormState state,
  ) async {
    final today = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: state.nextExecutionDate ?? today,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && context.mounted) {
      context.read<RecurringFormBloc>().add(
            RecurringFormNextExecutionChanged(selectedDate),
          );
    }
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      AppSnackBar.error(context, context.l10n.recurringErrorAmountInvalid);
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      AppSnackBar.error(context, context.l10n.recurringErrorAmountInvalid);
      return;
    }

    context.read<RecurringFormBloc>().add(
          RecurringFormSubmitted(
            amount: amount,
            note: _noteController.text,
          ),
        );
  }
}
