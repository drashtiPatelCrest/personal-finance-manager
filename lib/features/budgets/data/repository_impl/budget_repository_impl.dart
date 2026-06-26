import 'package:injectable/injectable.dart';

import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_params.dart';
import '../../domain/repository/budget_repository.dart';
import '../datasource/budget_local_datasource.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._localDataSource);

  final BudgetLocalDataSource _localDataSource;

  @override
  Future<List<Budget>> getBudgets({String? query}) {
    return _localDataSource.getBudgets(query: query);
  }

  @override
  Future<Budget?> getBudgetById(String id) {
    return _localDataSource.getBudgetById(id);
  }

  @override
  Future<Budget> createBudget(CreateBudgetParams params) {
    return _localDataSource.createBudget(params);
  }

  @override
  Future<Budget> updateBudget(UpdateBudgetParams params) {
    return _localDataSource.updateBudget(params);
  }

  @override
  Future<void> deleteBudget(String id) {
    return _localDataSource.deleteBudget(id);
  }

  @override
  Future<BudgetUsage> getBudgetUsage(String budgetId) {
    return _localDataSource.getBudgetUsage(budgetId);
  }

  @override
  Stream<List<Budget>> watchBudgets({String? query}) {
    return _localDataSource.watchBudgets(query: query);
  }
}
