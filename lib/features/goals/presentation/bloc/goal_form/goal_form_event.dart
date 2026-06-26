part of 'goal_form_bloc.dart';

sealed class GoalFormEvent extends Equatable {
  const GoalFormEvent();

  @override
  List<Object?> get props => [];
}

final class GoalFormLoadRequested extends GoalFormEvent {
  const GoalFormLoadRequested({this.goalId});

  final String? goalId;

  @override
  List<Object?> get props => [goalId];
}

final class GoalFormSubmitted extends GoalFormEvent {
  const GoalFormSubmitted({
    required this.name,
    required this.targetAmount,
  });

  final String name;
  final double targetAmount;

  @override
  List<Object?> get props => [name, targetAmount];
}

final class GoalFormDeadlineChanged extends GoalFormEvent {
  const GoalFormDeadlineChanged(this.deadline);

  final DateTime deadline;

  @override
  List<Object?> get props => [deadline];
}
