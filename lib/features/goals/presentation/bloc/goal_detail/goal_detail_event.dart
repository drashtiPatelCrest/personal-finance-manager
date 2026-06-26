part of 'goal_detail_bloc.dart';

sealed class GoalDetailEvent extends Equatable {
  const GoalDetailEvent();

  @override
  List<Object?> get props => [];
}

final class GoalDetailLoadRequested extends GoalDetailEvent {
  const GoalDetailLoadRequested(this.goalId);

  final String goalId;

  @override
  List<Object?> get props => [goalId];
}

final class GoalDetailContributionSubmitted extends GoalDetailEvent {
  const GoalDetailContributionSubmitted({
    required this.goalId,
    required this.amount,
    required this.date,
  });

  final String goalId;
  final double amount;
  final DateTime date;

  @override
  List<Object?> get props => [goalId, amount, date];
}

final class GoalDetailDeleteRequested extends GoalDetailEvent {
  const GoalDetailDeleteRequested(this.goalId);

  final String goalId;

  @override
  List<Object?> get props => [goalId];
}

final class GoalDetailGoalsUpdated extends GoalDetailEvent {
  const GoalDetailGoalsUpdated();
}
