import 'package:injectable/injectable.dart';

import '../../domain/entities/goal_params.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/repository/goal_repository.dart';
import '../datasource/goal_local_datasource.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl(this._localDataSource);

  final GoalLocalDataSource _localDataSource;

  @override
  Future<List<SavingsGoal>> getGoals({GoalStatus? status, String? query}) {
    return _localDataSource.getGoals(status: status, query: query);
  }

  @override
  Future<SavingsGoal?> getGoalById(String id) {
    return _localDataSource.getGoalById(id);
  }

  @override
  Future<SavingsGoal> createGoal(CreateGoalParams params) {
    return _localDataSource.createGoal(params);
  }

  @override
  Future<SavingsGoal> updateGoal(UpdateGoalParams params) {
    return _localDataSource.updateGoal(params);
  }

  @override
  Future<void> deleteGoal(String id) {
    return _localDataSource.deleteGoal(id);
  }

  @override
  Future<SavingsGoal> addContribution(AddContributionParams params) {
    return _localDataSource.addContribution(params);
  }

  @override
  Future<GoalProgress> getGoalProgress(String goalId) {
    return _localDataSource.getGoalProgress(goalId);
  }

  @override
  Stream<List<SavingsGoal>> watchGoals({GoalStatus? status, String? query}) {
    return _localDataSource.watchGoals(status: status, query: query);
  }
}
