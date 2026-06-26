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
import '../../domain/entities/budget.dart';
import '../bloc/budget_form/budget_form_bloc.dart';
import '../utils/budget_localization.dart';
import '../widgets/budget_error_banner.dart';

class BudgetFormPage extends StatefulWidget {
  const BudgetFormPage({
    super.key,
    this.budgetId,
    this.initialType,
  });

  final String? budgetId;
  final BudgetType? initialType;

  @override
  State<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends State<BudgetFormPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _fieldsInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.budgetId != null;

    return BlocProvider(
      create: (_) => getIt<BudgetFormBloc>()
        ..add(
          BudgetFormLoadRequested(
            budgetId: widget.budgetId,
            initialType: widget.initialType,
          ),
        ),
      child: BlocConsumer<BudgetFormBloc, BudgetFormState>(
        listener: (context, state) {
          if (!_fieldsInitialized && state.initialName != null) {
            _nameController.text = state.initialName!;
            _amountController.text = state.initialAmount!.toStringAsFixed(2);
            _fieldsInitialized = true;
          }
          if (state.saved) {
            AppSnackBar.success(
              context,
              isEditing ? l10n.budgetUpdateSuccess : l10n.budgetCreateSuccess,
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                isEditing ? l10n.budgetEditTitle : l10n.budgetCreateTitle,
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
                              child: BudgetErrorBanner(
                                errorCode: state.errorCode!,
                              ),
                            ),
                          if (!isEditing) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: AppChip(
                                    label: context.budgetTypeLabel(
                                      BudgetType.overall,
                                    ),
                                    selected:
                                        state.type == BudgetType.overall,
                                    onTap: () => context
                                        .read<BudgetFormBloc>()
                                        .add(
                                          const BudgetFormTypeChanged(
                                            BudgetType.overall,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: AppChip(
                                    label: context.budgetTypeLabel(
                                      BudgetType.category,
                                    ),
                                    selected:
                                        state.type == BudgetType.category,
                                    onTap: () => context
                                        .read<BudgetFormBloc>()
                                        .add(
                                          const BudgetFormTypeChanged(
                                            BudgetType.category,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          AppTextField(
                            controller: _nameController,
                            label: l10n.budgetNameLabel,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            controller: _amountController,
                            label: l10n.budgetAmountLabel,
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
                          if (state.type == BudgetType.category)
                            _buildCategoryDropdown(context, state),
                          if (state.type == BudgetType.category)
                            const SizedBox(height: AppSpacing.lg),
                          _buildDatePicker(
                            context,
                            label: l10n.budgetStartDateLabel,
                            date: state.startDate,
                            onSelected: (date) => context
                                .read<BudgetFormBloc>()
                                .add(BudgetFormStartDateChanged(date)),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _buildDatePicker(
                            context,
                            label: l10n.budgetEndDateLabel,
                            date: state.endDate,
                            onSelected: (date) => context
                                .read<BudgetFormBloc>()
                                .add(BudgetFormEndDateChanged(date)),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          AppButton(
                            label: isEditing
                                ? l10n.budgetSaveAction
                                : l10n.budgetCreateAction,
                            onPressed: state.isLoading ||
                                    (state.type == BudgetType.category &&
                                        state.categories.isEmpty)
                                ? null
                                : () => _submit(context),
                            isExpanded: true,
                            isLoading: state.isLoading,
                          ),
                          if (state.type == BudgetType.category &&
                              state.categories.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: AppSpacing.md),
                              child: AppText(
                                l10n.budgetNoCategoriesMessage,
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
    BudgetFormState state,
  ) {
    final l10n = context.l10n;

    return AppDropdown<String?>(
      label: l10n.budgetCategoryLabel,
      hint: l10n.budgetCategoryLabel,
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
      onChanged: (categoryId) => context.read<BudgetFormBloc>().add(
            BudgetFormCategoryChanged(categoryId),
          ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime> onSelected,
  }) {
    final formattedDate =
        DateFormat.yMMMd().format(date ?? DateTime.now());

    return AppOutlinedButton(
      label: '$label: $formattedDate',
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null && context.mounted) {
          onSelected(selectedDate);
        }
      },
      isExpanded: true,
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      AppSnackBar.error(context, context.l10n.budgetErrorAmountInvalid);
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      AppSnackBar.error(context, context.l10n.budgetErrorAmountInvalid);
      return;
    }

    context.read<BudgetFormBloc>().add(
          BudgetFormSubmitted(
            name: _nameController.text,
            amount: amount,
          ),
        );
  }
}
