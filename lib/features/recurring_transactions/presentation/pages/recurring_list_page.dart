import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../bloc/recurring_list/recurring_list_bloc.dart';
import '../utils/recurring_localization.dart';
import '../widgets/recurring_list_item.dart';
import '../widgets/recurring_status_filter.dart';

class RecurringListPage extends StatelessWidget {
  const RecurringListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<RecurringListBloc>()..add(const RecurringListStarted()),
      child: BlocConsumer<RecurringListBloc, RecurringListState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.recurringErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.recurringListTitle,
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
                  placeholder: l10n.recurringSearchPlaceholder,
                  onChanged: (query) => context.read<RecurringListBloc>().add(
                        RecurringListSearchChanged(query),
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                RecurringStatusFilter(
                  selectedPaused: state.selectedPaused,
                  onChanged: (isPaused) => context.read<RecurringListBloc>().add(
                        RecurringListStatusFilterChanged(isPaused),
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
      onPressed: () => context.push(RoutePaths.recurringAdd),
      icon: const Icon(Icons.add),
      label: Text(context.l10n.recurringAddAction),
    );
  }

  Widget _buildBody(BuildContext context, RecurringListState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.items.isEmpty) {
      return AppErrorState(
        onRetry: () => context.read<RecurringListBloc>().add(
              const RecurringListStarted(),
            ),
      );
    }

    if (state.items.isEmpty) {
      return AppEmptyState(
        icon: Icons.event_repeat_outlined,
        title: context.l10n.recurringEmptyTitle,
        message: context.l10n.recurringEmptyMessage,
        action: AppButton(
          label: context.l10n.recurringAddAction,
          onPressed: () => context.push(RoutePaths.recurringAdd),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final recurring = state.items[index];
        return RecurringListItem(
          recurring: recurring,
          onTap: () => context.push(RoutePaths.recurringDetailPath(recurring.id)),
          onDelete: () => _confirmDelete(context, recurring),
          onPause: () => context.read<RecurringListBloc>().add(
                RecurringListPauseRequested(recurring.id),
              ),
          onResume: () => context.read<RecurringListBloc>().add(
                RecurringListResumeRequested(recurring.id),
              ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    RecurringTransaction recurring,
  ) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.recurringDeleteConfirmTitle,
      message: l10n.recurringDeleteConfirmMessage(recurring.category.name),
      confirmLabel: l10n.recurringDeleteAction,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<RecurringListBloc>().add(
            RecurringListDeleteRequested(recurring.id),
          );
    }
  }
}
