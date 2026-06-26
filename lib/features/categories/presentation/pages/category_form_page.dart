import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/category.dart';
import '../bloc/category_form/category_form_bloc.dart';
import '../utils/category_localization.dart';
import '../widgets/category_color_picker.dart';
import '../widgets/category_error_banner.dart';
import '../widgets/category_icon_picker.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({
    super.key,
    this.categoryId,
    this.initialType,
  });

  final String? categoryId;
  final CategoryType? initialType;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _nameInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.categoryId != null;

    return BlocProvider(
      create: (_) => getIt<CategoryFormBloc>()
        ..add(
          CategoryFormLoadRequested(
            categoryId: widget.categoryId,
            initialType: widget.initialType,
          ),
        ),
      child: BlocConsumer<CategoryFormBloc, CategoryFormState>(
        listener: (context, state) {
          if (!_nameInitialized && state.initialName != null) {
            _nameController.text = state.initialName!;
            _nameInitialized = true;
          }
          if (state.saved) {
            AppSnackBar.success(
              context,
              isEditing ? l10n.categoryUpdateSuccess : l10n.categoryCreateSuccess,
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                isEditing ? l10n.categoryEditTitle : l10n.categoryCreateTitle,
                variant: AppTextVariant.titleLarge,
              ),
            ),
            bodyPadding: context.horizontalPagePadding,
            body: state.isLoading && state.isEditing && !_nameInitialized
                ? const AppLoadingIndicator()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
                              child: CategoryErrorBanner(
                                errorCode: state.errorCode!,
                              ),
                            ),
                          if (!isEditing) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: AppChip(
                                    label: context.categoryTypeLabel(
                                      CategoryType.income,
                                    ),
                                    selected:
                                        state.type == CategoryType.income,
                                    onTap: () => context
                                        .read<CategoryFormBloc>()
                                        .add(
                                          const CategoryFormTypeChanged(
                                            CategoryType.income,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: AppChip(
                                    label: context.categoryTypeLabel(
                                      CategoryType.expense,
                                    ),
                                    selected:
                                        state.type == CategoryType.expense,
                                    onTap: () => context
                                        .read<CategoryFormBloc>()
                                        .add(
                                          const CategoryFormTypeChanged(
                                            CategoryType.expense,
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
                            label: l10n.categoryNameLabel,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          CategoryIconPicker(
                            title: l10n.categoryIconLabel,
                            selectedIconCode: state.iconCode,
                            onIconSelected: (iconCode) => context
                                .read<CategoryFormBloc>()
                                .add(CategoryFormIconChanged(iconCode)),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          CategoryColorPicker(
                            title: l10n.categoryColorLabel,
                            selectedColorValue: state.colorValue,
                            onColorSelected: (colorValue) => context
                                .read<CategoryFormBloc>()
                                .add(CategoryFormColorChanged(colorValue)),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          AppButton(
                            label: isEditing
                                ? l10n.categorySaveAction
                                : l10n.categoryCreateAction,
                            onPressed: state.isLoading
                                ? null
                                : () => _submit(context),
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

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<CategoryFormBloc>().add(
          CategoryFormSubmitted(name: _nameController.text),
        );
  }
}
