import '../entities/budget.dart';
import '../entities/budget_params.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets({String? query});

  Future<Budget?> getBudgetById(String id);

  Future<Budget> createBudget(CreateBudgetParams params);

  Future<Budget> updateBudget(UpdateBudgetParams params);

  Future<void> deleteBudget(String id);

  Future<BudgetUsage> getBudgetUsage(String budgetId);

  Stream<List<Budget>> watchBudgets({String? query});
}
