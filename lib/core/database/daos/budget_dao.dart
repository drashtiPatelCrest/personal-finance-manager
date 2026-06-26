import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/budgets_table.dart';
import '../tables/categories_table.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets, Categories])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Stream<List<Budget>> watchBudgets({String? query}) {
    final statement = select(budgets);
    _applyQueryFilter(statement, query);
    statement.orderBy([(table) => OrderingTerm.desc(table.startDate)]);
    return statement.watch();
  }

  Future<List<Budget>> getBudgets({String? query}) {
    final statement = select(budgets);
    _applyQueryFilter(statement, query);
    statement.orderBy([(table) => OrderingTerm.desc(table.startDate)]);
    return statement.get();
  }

  Future<Budget?> getBudgetById(String id) {
    return (select(budgets)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertBudget(BudgetsCompanion budget) {
    return into(budgets).insert(budget);
  }

  Future<bool> updateBudget(BudgetsCompanion budget) async {
    final updated = await (update(budgets)
          ..where((table) => table.id.equals(budget.id.value)))
        .write(budget);
    return updated > 0;
  }

  Future<bool> deleteBudget(String id) async {
    final deleted =
        await (delete(budgets)..where((table) => table.id.equals(id))).go();
    return deleted > 0;
  }

  Future<bool> budgetNameExists({
    required String name,
    String? excludeId,
  }) async {
    final results =
        await (select(budgets)..where((table) => table.name.equals(name)))
            .get();
    if (excludeId == null) {
      return results.isNotEmpty;
    }
    return results.any((budget) => budget.id != excludeId);
  }

  void _applyQueryFilter(
    SimpleSelectStatement<$BudgetsTable, Budget> statement,
    String? query,
  ) {
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      statement.where((table) => table.name.like('%$trimmedQuery%'));
    }
  }
}
