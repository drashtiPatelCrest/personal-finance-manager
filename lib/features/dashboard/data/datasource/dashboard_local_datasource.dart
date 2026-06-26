import 'package:injectable/injectable.dart';

import '../../../budgets/data/datasource/budget_local_datasource.dart';
import '../../../goals/data/datasource/goal_local_datasource.dart';
import '../../../goals/domain/entities/savings_goal.dart';
import '../../../transactions/data/datasource/transaction_local_datasource.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/dashboard_error_code.dart';
import '../../domain/entities/dashboard_params.dart';
import '../../domain/entities/dashboard_snapshot.dart';

@lazySingleton
class DashboardLocalDataSource {
  DashboardLocalDataSource(
    this._transactionDataSource,
    this._budgetDataSource,
    this._goalDataSource,
  );

  final TransactionLocalDataSource _transactionDataSource;
  final BudgetLocalDataSource _budgetDataSource;
  final GoalLocalDataSource _goalDataSource;

  Future<DashboardSnapshot> getDashboardData(GetDashboardParams params) async {
    try {
      final summary = await _transactionDataSource.getSummary(
        startDate: params.startDate,
        endDate: params.endDate,
      );

      final transactions = await _transactionDataSource.getTransactions(
        filter: TransactionFilter(
          startDate: params.startDate,
          endDate: params.endDate,
        ),
      );
      final allTransactions = await _transactionDataSource.getTransactions();

      final budgets = await _budgetDataSource.getBudgets();
      final budgetUsages = await Future.wait(
        budgets.map((budget) => _budgetDataSource.getBudgetUsage(budget.id)),
      );

      final activeGoals = await _goalDataSource.getGoals(
        status: GoalStatus.active,
      );
      final activeGoalProgress = await Future.wait(
        activeGoals.map((goal) => _goalDataSource.getGoalProgress(goal.id)),
      );
      final totalSavings = activeGoals.fold<double>(
        0,
        (sum, goal) => sum + goal.currentAmount,
      );

      final monthlyTrend = await _buildMonthlyTrend(
        startDate: params.startDate,
        endDate: params.endDate,
      );
      final categoryDistribution = _buildCategoryDistribution(transactions);

      return DashboardSnapshot(
        totalIncome: summary['income']?.toDouble() ?? 0,
        totalExpense: summary['expense']?.toDouble() ?? 0,
        totalSavings: totalSavings,
        activeGoalsCount: activeGoals.length,
        activeGoals: activeGoalProgress,
        budgetUsages: budgetUsages,
        monthlyTrend: monthlyTrend,
        categoryDistribution: categoryDistribution,
        hasTransactions: transactions.isNotEmpty,
        hasAnyTransactions: allTransactions.isNotEmpty,
      );
    } catch (_) {
      throw const DashboardException(DashboardErrorCode.unknown);
    }
  }

  Future<List<MonthlyTrendPoint>> _buildMonthlyTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final months = <DateTime>[];
    var cursor = DateTime(startDate.year, startDate.month);
    final endMonth = DateTime(endDate.year, endDate.month);

    while (cursor.year < endMonth.year ||
        (cursor.year == endMonth.year && cursor.month <= endMonth.month)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    final summaries = await Future.wait(
      months.map((month) async {
        final monthStart = DateTime(month.year, month.month);
        final monthEnd =
            DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
        final rangeStart = monthStart.isBefore(startDate) ? startDate : monthStart;
        final rangeEnd = monthEnd.isAfter(endDate) ? endDate : monthEnd;

        final summary = await _transactionDataSource.getSummary(
          startDate: rangeStart,
          endDate: rangeEnd,
        );

        return MonthlyTrendPoint(
          year: month.year,
          month: month.month,
          income: summary['income']?.toDouble() ?? 0,
          expense: summary['expense']?.toDouble() ?? 0,
        );
      }),
    );

    return summaries;
  }

  List<CategoryDistributionItem> _buildCategoryDistribution(
    List<Transaction> transactions,
  ) {
    final totals = <String, CategoryDistributionItem>{};

    for (final transaction in transactions) {
      if (transaction.type != TransactionType.expense) {
        continue;
      }

      final category = transaction.category;
      final existing = totals[category.id];
      if (existing == null) {
        totals[category.id] = CategoryDistributionItem(
          categoryId: category.id,
          categoryName: category.name,
          colorValue: category.colorValue,
          amount: transaction.amount,
        );
      } else {
        totals[category.id] = CategoryDistributionItem(
          categoryId: category.id,
          categoryName: category.name,
          colorValue: category.colorValue,
          amount: existing.amount + transaction.amount,
        );
      }
    }

    final items = totals.values.toList()
      ..sort((first, second) => second.amount.compareTo(first.amount));
    return items;
  }
}
