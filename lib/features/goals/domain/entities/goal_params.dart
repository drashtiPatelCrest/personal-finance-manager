import 'package:equatable/equatable.dart';

import 'savings_goal.dart';
class CreateGoalParams extends Equatable {
  const CreateGoalParams({
    required this.name,
    required this.targetAmount,
    required this.deadline,
  });

  final String name;
  final double targetAmount;
  final DateTime deadline;

  @override
  List<Object?> get props => [name, targetAmount, deadline];
}

class UpdateGoalParams extends Equatable {
  const UpdateGoalParams({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.deadline,
  });

  final String id;
  final String name;
  final double targetAmount;
  final DateTime deadline;

  @override
  List<Object?> get props => [id, name, targetAmount, deadline];
}

class DeleteGoalParams extends Equatable {
  const DeleteGoalParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class AddContributionParams extends Equatable {
  const AddContributionParams({
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

class WatchGoalsParams extends Equatable {
  const WatchGoalsParams({this.status, this.query});

  final GoalStatus? status;
  final String? query;

  @override
  List<Object?> get props => [status, query];
}

class GetGoalsParams extends Equatable {
  const GetGoalsParams({this.status, this.query});

  final GoalStatus? status;
  final String? query;

  @override
  List<Object?> get props => [status, query];
}

class GetGoalByIdParams extends Equatable {
  const GetGoalByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class GetGoalProgressParams extends Equatable {
  const GetGoalProgressParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
