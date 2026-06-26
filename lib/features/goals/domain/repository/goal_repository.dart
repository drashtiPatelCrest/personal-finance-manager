import '../entities/goal_params.dart';
import '../entities/savings_goal.dart';

abstract class GoalRepository {
  Future<List<SavingsGoal>> getGoals({GoalStatus? status, String? query});

  Future<SavingsGoal?> getGoalById(String id);

  Future<SavingsGoal> createGoal(CreateGoalParams params);

  Future<SavingsGoal> updateGoal(UpdateGoalParams params);

  Future<void> deleteGoal(String id);

  Future<SavingsGoal> addContribution(AddContributionParams params);

  Future<GoalProgress> getGoalProgress(String goalId);

  Stream<List<SavingsGoal>> watchGoals({GoalStatus? status, String? query});
}
