import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/savings_goal.dart';
import '../bloc/goal_list/goal_list_bloc.dart';
import '../utils/goal_localization.dart';
import '../widgets/goal_list_item.dart';
import '../widgets/goal_status_filter.dart';

class GoalListPage extends StatelessWidget {
  const GoalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<GoalListBloc>()..add(const GoalListStarted()),
      child: BlocConsumer<GoalListBloc, GoalListState>(
        listenWhen: (previous, current) =>
            current.errorCode != null &&
            previous.errorNonce != current.errorNonce,
        listener: (context, state) {
          AppSnackBar.error(
            context,
            context.goalErrorMessage(state.errorCode!),
          );
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.goalListTitle,
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
                  placeholder: l10n.goalSearchPlaceholder,
                  onChanged: (query) => context.read<GoalListBloc>().add(
                        GoalListSearchChanged(query),
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GoalStatusFilter(
                  selectedStatus: state.selectedStatus,
                  onChanged: (status) => context.read<GoalListBloc>().add(
                        GoalListStatusFilterChanged(status),
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
      onPressed: () => context.push(RoutePaths.goalAdd),
      icon: const Icon(Icons.add),
      label: Text(context.l10n.goalAddAction),
    );
  }

  Widget _buildBody(BuildContext context, GoalListState state) {
    if (state.isLoading && state.goals.isEmpty) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.goals.isEmpty) {
      return AppErrorState(
        onRetry: () => context.read<GoalListBloc>().add(
              const GoalListStarted(),
            ),
      );
    }

    if (state.goals.isEmpty) {
      return AppEmptyState(
        icon: Icons.savings_outlined,
        title: context.l10n.goalEmptyTitle,
        message: context.l10n.goalEmptyMessage,
        action: AppButton(
          label: context.l10n.goalAddAction,
          onPressed: () => context.push(RoutePaths.goalAdd),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.goals.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final goal = state.goals[index];
        return GoalListItem(
          goal: goal,
          progress: state.progressMap[goal.id],
          onTap: () => context.push(RoutePaths.goalDetailPath(goal.id)),
          onDelete: () => _confirmDelete(context, goal),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, SavingsGoal goal) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.goalDeleteConfirmTitle,
      message: l10n.goalDeleteConfirmMessage(goal.name),
      confirmLabel: l10n.goalDeleteAction,
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<GoalListBloc>().add(
            GoalListDeleteRequested(goal.id),
          );
    }
  }
}
