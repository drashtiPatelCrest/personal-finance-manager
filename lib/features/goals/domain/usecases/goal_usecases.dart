import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/goal_params.dart';
import '../entities/savings_goal.dart';
import '../repository/goal_repository.dart';

@injectable
class WatchGoalsUseCase
    implements UseCase<Stream<List<SavingsGoal>>, WatchGoalsParams> {
  WatchGoalsUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<Stream<List<SavingsGoal>>> call(WatchGoalsParams params) async {
    return _repository.watchGoals(status: params.status, query: params.query);
  }
}

@injectable
class GetGoalsUseCase implements UseCase<List<SavingsGoal>, GetGoalsParams> {
  GetGoalsUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<List<SavingsGoal>> call(GetGoalsParams params) {
    return _repository.getGoals(status: params.status, query: params.query);
  }
}

@injectable
class GetGoalByIdUseCase implements UseCase<SavingsGoal?, GetGoalByIdParams> {
  GetGoalByIdUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<SavingsGoal?> call(GetGoalByIdParams params) {
    return _repository.getGoalById(params.id);
  }
}

@injectable
class CreateGoalUseCase implements UseCase<SavingsGoal, CreateGoalParams> {
  CreateGoalUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<SavingsGoal> call(CreateGoalParams params) {
    return _repository.createGoal(params);
  }
}

@injectable
class UpdateGoalUseCase implements UseCase<SavingsGoal, UpdateGoalParams> {
  UpdateGoalUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<SavingsGoal> call(UpdateGoalParams params) {
    return _repository.updateGoal(params);
  }
}

@injectable
class DeleteGoalUseCase implements UseCase<void, DeleteGoalParams> {
  DeleteGoalUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<void> call(DeleteGoalParams params) {
    return _repository.deleteGoal(params.id);
  }
}

@injectable
class AddContributionUseCase
    implements UseCase<SavingsGoal, AddContributionParams> {
  AddContributionUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<SavingsGoal> call(AddContributionParams params) {
    return _repository.addContribution(params);
  }
}

@injectable
class GetGoalProgressUseCase
    implements UseCase<GoalProgress, GetGoalProgressParams> {
  GetGoalProgressUseCase(this._repository);

  final GoalRepository _repository;

  @override
  Future<GoalProgress> call(GetGoalProgressParams params) {
    return _repository.getGoalProgress(params.id);
  }
}
