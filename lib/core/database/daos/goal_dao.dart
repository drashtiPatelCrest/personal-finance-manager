import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/goal_contributions_table.dart';
import '../tables/savings_goals_table.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [SavingsGoals, GoalContributions])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(super.db);

  Stream<List<SavingsGoal>> watchGoals({String? status, String? query}) {
    final statement = select(savingsGoals);
    _applyFilters(statement, status: status, query: query);
    statement.orderBy([(table) => OrderingTerm.asc(table.deadline)]);
    return statement.watch();
  }

  Future<List<SavingsGoal>> getGoals({String? status, String? query}) {
    final statement = select(savingsGoals);
    _applyFilters(statement, status: status, query: query);
    statement.orderBy([(table) => OrderingTerm.asc(table.deadline)]);
    return statement.get();
  }

  Future<SavingsGoal?> getGoalById(String id) {
    return (select(savingsGoals)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertGoal(SavingsGoalsCompanion goal) {
    return into(savingsGoals).insert(goal);
  }

  Future<bool> updateGoal(SavingsGoalsCompanion goal) async {
    final updated = await (update(savingsGoals)
          ..where((table) => table.id.equals(goal.id.value)))
        .write(goal);
    return updated > 0;
  }

  Future<bool> deleteGoal(String id) async {
    final deleted =
        await (delete(savingsGoals)..where((table) => table.id.equals(id)))
            .go();
    return deleted > 0;
  }

  Future<bool> goalNameExists({
    required String name,
    String? excludeId,
  }) async {
    final results =
        await (select(savingsGoals)..where((table) => table.name.equals(name)))
            .get();
    if (excludeId == null) {
      return results.isNotEmpty;
    }
    return results.any((goal) => goal.id != excludeId);
  }

  Future<void> insertContribution(GoalContributionsCompanion contribution) {
    return into(goalContributions).insert(contribution);
  }

  Future<List<GoalContribution>> getContributionsForGoal(String goalId) {
    return (select(goalContributions)
          ..where((table) => table.goalId.equals(goalId))
          ..orderBy([(table) => OrderingTerm.desc(table.date)]))
        .get();
  }

  Future<double> sumContributionsForGoal(String goalId) async {
    final amountSum = goalContributions.amount.sum();
    final query = selectOnly(goalContributions)
      ..addColumns([amountSum])
      ..where(goalContributions.goalId.equals(goalId));
    final row = await query.getSingleOrNull();
    return row?.read(amountSum) ?? 0;
  }

  void _applyFilters(
    SimpleSelectStatement<$SavingsGoalsTable, SavingsGoal> statement, {
    String? status,
    String? query,
  }) {
    if (status != null) {
      statement.where((table) => table.status.equals(status));
    }
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      statement.where((table) => table.name.like('%$trimmedQuery%'));
    }
  }
}
