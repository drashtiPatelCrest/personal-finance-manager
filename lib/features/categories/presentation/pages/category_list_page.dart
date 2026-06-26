import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/category.dart';
import '../bloc/category_list/category_list_bloc.dart';
import '../utils/category_localization.dart';
import '../widgets/category_list_item.dart';
import '../widgets/category_type_filter.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<CategoryListBloc>()..add(const CategoryListStarted()),
      child: BlocConsumer<CategoryListBloc, CategoryListState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.categoryErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.categoryListTitle,
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
                  placeholder: l10n.categorySearchPlaceholder,
                  onChanged: (query) => context.read<CategoryListBloc>().add(
                        CategoryListSearchChanged(query),
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CategoryTypeFilter(
                  selectedType: state.selectedType,
                  onChanged: (type) => context.read<CategoryListBloc>().add(
                        CategoryListTypeFilterChanged(type),
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
      label: Text(context.l10n.categoryAddAction),
    );
  }

  Widget _buildBody(BuildContext context, CategoryListState state) {
    if (state.isLoading && state.categories.isEmpty) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.categories.isEmpty) {
      return AppErrorState(
        onRetry: () => context.read<CategoryListBloc>().add(
              CategoryListStarted(initialType: state.selectedType),
            ),
      );
    }

    if (state.categories.isEmpty) {
      return AppEmptyState(
        icon: Icons.category_outlined,
        title: context.l10n.categoryEmptyTitle,
        message: context.l10n.categoryEmptyMessage,
        action: AppButton(
          label: context.l10n.categoryAddAction,
          onPressed: () => _openCreateMenu(context),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.categories.length,
      separatorBuilder: (_, __) => const AppDivider(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final category = state.categories[index];
        return CategoryListItem(
          category: category,
          onTap: () => context.push(RoutePaths.categoryEditPath(category.id)),
          onDelete: () => _confirmDelete(context, category),
        );
      },
    );
  }

  Future<void> _openCreateMenu(BuildContext context) async {
    final l10n = context.l10n;
    await AppBottomSheet.show<void>(
      context: context,
      semanticsLabel: l10n.categoryAddAction,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(l10n.categoryAddAction, variant: AppTextVariant.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.categoryCreateIncomeAction,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(
                  RoutePaths.categoryAddPath(type: 'income'),
                );
              },
              isExpanded: true,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: l10n.categoryCreateExpenseAction,
              variant: AppButtonVariant.tonal,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(
                  RoutePaths.categoryAddPath(type: 'expense'),
                );
              },
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.categoryDeleteConfirmTitle,
      message: l10n.categoryDeleteConfirmMessage(category.name),
      confirmLabel: l10n.categoryDeleteAction,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<CategoryListBloc>().add(
            CategoryListDeleteRequested(category.id),
          );
    }
  }
}
