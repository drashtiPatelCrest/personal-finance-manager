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
import '../bloc/goal_form/goal_form_bloc.dart';
import '../widgets/goal_error_banner.dart';

class GoalFormPage extends StatefulWidget {
  const GoalFormPage({super.key, this.goalId});

  final String? goalId;

  @override
  State<GoalFormPage> createState() => _GoalFormPageState();
}

class _GoalFormPageState extends State<GoalFormPage> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _fieldsInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.goalId != null;

    return BlocProvider(
      create: (_) => getIt<GoalFormBloc>()
        ..add(GoalFormLoadRequested(goalId: widget.goalId)),
      child: BlocConsumer<GoalFormBloc, GoalFormState>(
        listener: (context, state) {
          if (!_fieldsInitialized && state.initialName != null) {
            _nameController.text = state.initialName!;
            _targetController.text =
                state.initialTargetAmount!.toStringAsFixed(2);
            _fieldsInitialized = true;
          }
          if (state.saved) {
            AppSnackBar.success(
              context,
              isEditing ? l10n.goalUpdateSuccess : l10n.goalCreateSuccess,
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                isEditing ? l10n.goalEditTitle : l10n.goalCreateTitle,
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
                              child: GoalErrorBanner(
                                errorCode: state.errorCode!,
                              ),
                            ),
                          AppTextField(
                            controller: _nameController,
                            label: l10n.goalNameLabel,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            controller: _targetController,
                            label: l10n.goalTargetAmountLabel,
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
                          _buildDeadlinePicker(context, state),
                          const SizedBox(height: AppSpacing.xxl),
                          AppButton(
                            label: isEditing
                                ? l10n.goalSaveAction
                                : l10n.goalCreateAction,
                            onPressed:
                                state.isLoading ? null : () => _submit(context),
                            isExpanded: true,
                            isLoading: state.isLoading,
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

  Widget _buildDeadlinePicker(BuildContext context, GoalFormState state) {
    final l10n = context.l10n;
    final deadline = state.deadline ?? DateTime.now();
    final formattedDate = DateFormat.yMMMd().format(deadline);

    return AppOutlinedButton(
      label: '${l10n.goalDeadlineLabel}: $formattedDate',
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: deadline,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null && context.mounted) {
          context.read<GoalFormBloc>().add(
                GoalFormDeadlineChanged(selectedDate),
              );
        }
      },
      isExpanded: true,
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final targetText = _targetController.text.trim();
    if (targetText.isEmpty) {
      AppSnackBar.error(context, context.l10n.goalErrorTargetAmountInvalid);
      return;
    }

    final targetAmount = double.tryParse(targetText);
    if (targetAmount == null || targetAmount <= 0) {
      AppSnackBar.error(context, context.l10n.goalErrorTargetAmountInvalid);
      return;
    }

    context.read<GoalFormBloc>().add(
          GoalFormSubmitted(
            name: _nameController.text,
            targetAmount: targetAmount,
          ),
        );
  }
}
