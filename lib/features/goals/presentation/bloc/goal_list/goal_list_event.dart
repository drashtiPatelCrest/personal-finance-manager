part of 'goal_list_bloc.dart';

sealed class GoalListEvent extends Equatable {
  const GoalListEvent();

  @override
  List<Object?> get props => [];
}

final class GoalListStarted extends GoalListEvent {
  const GoalListStarted();
}

final class GoalListSearchChanged extends GoalListEvent {
  const GoalListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class GoalListStatusFilterChanged extends GoalListEvent {
  const GoalListStatusFilterChanged(this.status);

  final GoalStatus? status;

  @override
  List<Object?> get props => [status];
}

final class GoalListDeleteRequested extends GoalListEvent {
  const GoalListDeleteRequested(this.goalId);

  final String goalId;

  @override
  List<Object?> get props => [goalId];
}

final class GoalListUpdated extends GoalListEvent {
  const GoalListUpdated(this.goals);

  final List<SavingsGoal> goals;

  @override
  List<Object?> get props => [goals];
}

final class GoalListFailed extends GoalListEvent {
  const GoalListFailed(this.errorCode);

  final GoalErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
