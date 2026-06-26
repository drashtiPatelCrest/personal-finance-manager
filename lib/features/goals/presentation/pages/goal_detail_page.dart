import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../domain/entities/savings_goal.dart';
import '../bloc/goal_detail/goal_detail_bloc.dart';
import '../utils/goal_localization.dart';
import '../widgets/goal_error_banner.dart';
import '../widgets/goal_progress_card.dart';

class GoalDetailPage extends StatefulWidget {
  const GoalDetailPage({super.key, required this.goalId});

  final String goalId;

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  final _contributionController = TextEditingController();

  @override
  void dispose() {
    _contributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<GoalDetailBloc>()
        ..add(GoalDetailLoadRequested(widget.goalId)),
      child: BlocConsumer<GoalDetailBloc, GoalDetailState>(
        listenWhen: (previous, current) =>
            current.deleted ||
            current.contributionAdded ||
            (current.errorCode != null &&
                previous.errorNonce != current.errorNonce),
        listener: (context, state) {
          if (state.deleted) {
            AppSnackBar.success(context, l10n.goalDeleteSuccess);
            context.pop();
          }
          if (state.contributionAdded) {
            AppSnackBar.success(context, l10n.goalContributionSuccess);
            _contributionController.clear();
          }
          if (state.errorCode != null &&
              !state.isContributing &&
              !state.isDeleting) {
            AppSnackBar.error(
              context,
              context.goalErrorMessage(state.errorCode!),
            );
          }
        },
        builder: (context, state) {
          return AppScaffold(
            constrainBodyWidth: true,
            appBar: AppAppBar(
              title: AppText(
                l10n.goalDetailTitle,
                variant: AppTextVariant.titleLarge,
              ),
              actions: [
                if (state.progress != null)
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: l10n.goalEditTitle,
                    onPressed: () async {
                      await context.push(
                        RoutePaths.goalEditPath(widget.goalId),
                      );
                      if (context.mounted) {
                        context.read<GoalDetailBloc>().add(
                              GoalDetailLoadRequested(widget.goalId),
                            );
                      }
                    },
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

  Widget _buildBody(BuildContext context, GoalDetailState state) {
    if (state.isLoading && state.progress == null) {
      return const AppLoadingIndicator();
    }

    if (state.isFailure && state.progress == null) {
      return Column(
        children: [
          if (state.errorCode != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: GoalErrorBanner(errorCode: state.errorCode!),
            ),
          Expanded(
            child: AppErrorState(
              onRetry: () => context.read<GoalDetailBloc>().add(
                    GoalDetailLoadRequested(widget.goalId),
                  ),
            ),
          ),
        ],
      );
    }

    final progress = state.progress;
    if (progress == null) {
      return const AppLoadingIndicator();
    }

    final goal = progress.goal;
    final dateFormat = DateFormat.yMMMMd();
    final canContribute = progress.effectiveStatus == GoalStatus.active;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(goal.name, variant: AppTextVariant.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    context.goalStatusLabel(progress.effectiveStatus),
                    variant: AppTextVariant.caption,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GoalProgressCard(progress: progress),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildDetailRow(
            context,
            label: context.l10n.goalTargetLabel,
            value: context.formatGoalCurrency(goal.targetAmount),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.goalSavedLabel,
            value: context.formatGoalCurrency(goal.currentAmount),
          ),
          _buildDetailRow(
            context,
            label: context.l10n.goalDeadlineLabel,
            value: dateFormat.format(goal.deadline),
          ),
          if (canContribute) ...[
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: _contributionController,
              label: context.l10n.goalContributionAmountLabel,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: context.l10n.goalAddContributionAction,
              onPressed: state.isContributing
                  ? null
                  : () => _submitContribution(context),
              isExpanded: true,
              isLoading: state.isContributing,
            ),
          ],
          if (progress.contributions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            AppText(
              context.l10n.goalContributionsTitle,
              variant: AppTextVariant.titleSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            ...progress.contributions.map(
              (contribution) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppListTile(
                  title: AppText(
                    context.formatGoalCurrency(contribution.amount),
                    variant: AppTextVariant.bodyMedium,
                  ),
                  subtitle: AppText(
                    dateFormat.format(contribution.date),
                    variant: AppTextVariant.caption,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: context.l10n.goalEditTitle,
            onPressed: () async {
              await context.push(RoutePaths.goalEditPath(widget.goalId));
              if (context.mounted) {
                context.read<GoalDetailBloc>().add(
                      GoalDetailLoadRequested(widget.goalId),
                    );
              }
            },
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppOutlinedButton(
            label: context.l10n.goalDeleteAction,
            onPressed:
                state.isDeleting ? null : () => _confirmDelete(context, goal),
            isExpanded: true,
            isLoading: state.isDeleting,
          ),
        ],
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

  void _submitContribution(BuildContext context) {
    final amountText = _contributionController.text.trim();
    if (amountText.isEmpty) {
      AppSnackBar.error(
        context,
        context.l10n.goalErrorContributionAmountInvalid,
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      AppSnackBar.error(
        context,
        context.l10n.goalErrorContributionAmountInvalid,
      );
      return;
    }

    context.read<GoalDetailBloc>().add(
          GoalDetailContributionSubmitted(
            goalId: widget.goalId,
            amount: amount,
            date: DateTime.now(),
          ),
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
      context.read<GoalDetailBloc>().add(
            GoalDetailDeleteRequested(widget.goalId),
          );
    }
  }
}
