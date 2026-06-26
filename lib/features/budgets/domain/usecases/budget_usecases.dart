import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../entities/budget_params.dart';
import '../repository/budget_repository.dart';

@injectable
class WatchBudgetsUseCase
    implements UseCase<Stream<List<Budget>>, WatchBudgetsParams> {
  WatchBudgetsUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Stream<List<Budget>>> call(WatchBudgetsParams params) async {
    return _repository.watchBudgets(query: params.query);
  }
}

@injectable
class GetBudgetsUseCase implements UseCase<List<Budget>, GetBudgetsParams> {
  GetBudgetsUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<List<Budget>> call(GetBudgetsParams params) {
    return _repository.getBudgets(query: params.query);
  }
}

@injectable
class GetBudgetByIdUseCase implements UseCase<Budget?, GetBudgetByIdParams> {
  GetBudgetByIdUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Budget?> call(GetBudgetByIdParams params) {
    return _repository.getBudgetById(params.id);
  }
}

@injectable
class CreateBudgetUseCase implements UseCase<Budget, CreateBudgetParams> {
  CreateBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Budget> call(CreateBudgetParams params) {
    return _repository.createBudget(params);
  }
}

@injectable
class UpdateBudgetUseCase implements UseCase<Budget, UpdateBudgetParams> {
  UpdateBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<Budget> call(UpdateBudgetParams params) {
    return _repository.updateBudget(params);
  }
}

@injectable
class DeleteBudgetUseCase implements UseCase<void, DeleteBudgetParams> {
  DeleteBudgetUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<void> call(DeleteBudgetParams params) {
    return _repository.deleteBudget(params.id);
  }
}

@injectable
class GetBudgetUsageUseCase implements UseCase<BudgetUsage, GetBudgetUsageParams> {
  GetBudgetUsageUseCase(this._repository);

  final BudgetRepository _repository;

  @override
  Future<BudgetUsage> call(GetBudgetUsageParams params) {
    return _repository.getBudgetUsage(params.id);
  }
}
