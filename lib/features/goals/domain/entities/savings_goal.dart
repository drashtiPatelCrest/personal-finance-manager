import 'package:equatable/equatable.dart';

enum GoalStatus { active, completed, expired }

class SavingsGoal extends Equatable {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.status,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final GoalStatus status;

  double get remainingAmount => targetAmount - currentAmount;

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        currentAmount,
        deadline,
        status,
      ];
}

class GoalContribution extends Equatable {
  const GoalContribution({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
  });

  final String id;
  final String goalId;
  final double amount;
  final DateTime date;

  @override
  List<Object?> get props => [id, goalId, amount, date];
}

class GoalProgress extends Equatable {
  const GoalProgress({
    required this.goal,
    required this.completionPercentage,
    required this.contributions,
  });

  final SavingsGoal goal;
  final double completionPercentage;
  final List<GoalContribution> contributions;

  GoalStatus get effectiveStatus => resolveGoalStatus(
        currentAmount: goal.currentAmount,
        targetAmount: goal.targetAmount,
        deadline: goal.deadline,
      );

  static GoalStatus resolveGoalStatus({
    required double currentAmount,
    required double targetAmount,
    required DateTime deadline,
    DateTime? referenceDate,
  }) {
    if (currentAmount >= targetAmount) {
      return GoalStatus.completed;
    }

    final now = referenceDate ?? DateTime.now();
    final deadlineEnd = DateTime(
      deadline.year,
      deadline.month,
      deadline.day,
      23,
      59,
      59,
      999,
    );
    if (now.isAfter(deadlineEnd)) {
      return GoalStatus.expired;
    }

    return GoalStatus.active;
  }

  static double calculateCompletionPercentage({
    required double currentAmount,
    required double targetAmount,
  }) {
    if (targetAmount <= 0) {
      return 0;
    }
    return (currentAmount / targetAmount) * 100;
  }

  @override
  List<Object?> get props => [goal, completionPercentage, contributions];
}
