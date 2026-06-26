import 'package:injectable/injectable.dart';

import '../../../budgets/data/datasource/budget_local_datasource.dart';
import '../../../budgets/domain/entities/budget.dart';
import '../../../categories/data/datasource/category_local_datasource.dart';
import '../../../goals/data/datasource/goal_local_datasource.dart';
import '../../../goals/domain/entities/savings_goal.dart';
import '../../../transactions/data/datasource/transaction_local_datasource.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/financial_report.dart';
import '../../domain/entities/report_error_code.dart';

@lazySingleton
class ReportLocalDataSource {
  ReportLocalDataSource(
    this._transactionDataSource,
    this._budgetDataSource,
    this._goalDataSource,
    this._categoryDataSource,
  );

  final TransactionLocalDataSource _transactionDataSource;
  final BudgetLocalDataSource _budgetDataSource;
  final GoalLocalDataSource _goalDataSource;
  final CategoryLocalDataSource _categoryDataSource;

  Future<FinancialReport> generateReport(ReportFilter filter) async {
    try {
      final range = _resolveDateRange(filter);

      return switch (filter.type) {
        ReportType.monthly => _buildTransactionReport(
            type: filter.type,
            startDate: range.startDate,
            endDate: range.endDate,
            categoryId: filter.categoryId,
          ),
        ReportType.yearly => _buildTransactionReport(
            type: filter.type,
            startDate: range.startDate,
            endDate: range.endDate,
            categoryId: filter.categoryId,
          ),
        ReportType.category => _buildTransactionReport(
            type: filter.type,
            startDate: range.startDate,
            endDate: range.endDate,
            categoryId: filter.categoryId,
          ),
        ReportType.budget => _buildBudgetReport(
            startDate: range.startDate,
            endDate: range.endDate,
          ),
        ReportType.goal => _buildGoalReport(),
      };
    } catch (_) {
      throw const ReportException(ReportErrorCode.unknown);
    }
  }

  Future<FinancialReport> _buildTransactionReport({
    required ReportType type,
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  }) async {
    final summary = await _transactionDataSource.getSummary(
      startDate: startDate,
      endDate: endDate,
    );

    final transactions = await _transactionDataSource.getTransactions(
      filter: TransactionFilter(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      ),
    );

    final totalIncome = categoryId == null
        ? summary['income']?.toDouble() ?? 0
        : transactions
            .where((transaction) => transaction.type == TransactionType.income)
            .fold<double>(0, (sum, transaction) => sum + transaction.amount);
    final totalExpense = categoryId == null
        ? summary['expense']?.toDouble() ?? 0
        : transactions
            .where((transaction) => transaction.type == TransactionType.expense)
            .fold<double>(0, (sum, transaction) => sum + transaction.amount);

    String? categoryName;
    if (categoryId != null) {
      final category = await _categoryDataSource.getCategoryById(categoryId);
      categoryName = category?.name;
    }

    final monthlyTrend = await _buildMonthlyTrend(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );
    final categoryDistribution = _buildCategoryDistribution(transactions);

    return FinancialReport(
      type: type,
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      categoryName: categoryName,
      summary: ReportSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        transactionCount: transactions.length,
      ),
      monthlyTrend: monthlyTrend,
      categoryDistribution: categoryDistribution,
      budgetUsages: const [],
      goalProgress: const [],
      hasData: transactions.isNotEmpty,
    );
  }

  Future<FinancialReport> _buildBudgetReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final budgets = await _budgetDataSource.getBudgets();
    final overlappingBudgets = budgets.where((budget) {
      return !budget.endDate.isBefore(startDate) &&
          !budget.startDate.isAfter(endDate);
    }).toList();

    final budgetUsages = await Future.wait(
      overlappingBudgets.map((budget) async {
        final rangeStart =
            budget.startDate.isBefore(startDate) ? startDate : budget.startDate;
        final rangeEnd =
            budget.endDate.isAfter(endDate) ? endDate : budget.endDate;

        final spentAmount = await _transactionDataSource.sumExpenses(
          startDate: rangeStart,
          endDate: rangeEnd,
          categoryId: budget.categoryId,
        );

        String? categoryName;
        if (budget.categoryId != null) {
          final category =
              await _categoryDataSource.getCategoryById(budget.categoryId!);
          categoryName = category?.name;
        }

        final remainingAmount = budget.amount - spentAmount;
        final usagePercentage = budget.amount > 0
            ? (spentAmount / budget.amount) * 100.0
            : 0.0;

        return BudgetUsage(
          budget: budget,
          spentAmount: spentAmount,
          remainingAmount: remainingAmount,
          usagePercentage: usagePercentage,
          categoryName: categoryName,
        );
      }),
    );

    final exceededCount =
        budgetUsages.where((usage) => usage.status == BudgetStatus.exceeded).length;
    final warningCount =
        budgetUsages.where((usage) => usage.status == BudgetStatus.warning).length;

    return FinancialReport(
      type: ReportType.budget,
      startDate: startDate,
      endDate: endDate,
      summary: ReportSummary(
        totalIncome: 0,
        totalExpense: budgetUsages.fold<double>(
          0,
          (sum, usage) => sum + usage.spentAmount,
        ),
        transactionCount: 0,
        totalBudgets: budgetUsages.length,
        exceededBudgetCount: exceededCount,
        warningBudgetCount: warningCount,
      ),
      monthlyTrend: const [],
      categoryDistribution: const [],
      budgetUsages: budgetUsages,
      goalProgress: const [],
      hasData: budgetUsages.isNotEmpty,
    );
  }

  Future<FinancialReport> _buildGoalReport() async {
    final goals = await _goalDataSource.getGoals();
    final goalProgress = await Future.wait(
      goals.map((goal) => _goalDataSource.getGoalProgress(goal.id)),
    );

    final activeCount = goalProgress
        .where((progress) => progress.effectiveStatus == GoalStatus.active)
        .length;
    final completedCount = goalProgress
        .where((progress) => progress.effectiveStatus == GoalStatus.completed)
        .length;
    final totalSavings = goals.fold<double>(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );

    final now = DateTime.now();

    return FinancialReport(
      type: ReportType.goal,
      startDate: DateTime(now.year),
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
      summary: ReportSummary(
        totalIncome: 0,
        totalExpense: 0,
        transactionCount: 0,
        totalSavings: totalSavings,
        activeGoalCount: activeCount,
        completedGoalCount: completedCount,
      ),
      monthlyTrend: const [],
      categoryDistribution: const [],
      budgetUsages: const [],
      goalProgress: goalProgress,
      hasData: goalProgress.isNotEmpty,
    );
  }

  Future<List<ReportTrendPoint>> _buildMonthlyTrend({
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  }) async {
    final months = <DateTime>[];
    var cursor = DateTime(startDate.year, startDate.month);
    final endMonth = DateTime(endDate.year, endDate.month);

    while (cursor.year < endMonth.year ||
        (cursor.year == endMonth.year && cursor.month <= endMonth.month)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return Future.wait(
      months.map((month) async {
        final monthStart = DateTime(month.year, month.month);
        final monthEnd =
            DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
        final rangeStart = monthStart.isBefore(startDate) ? startDate : monthStart;
        final rangeEnd = monthEnd.isAfter(endDate) ? endDate : monthEnd;

        final transactions = await _transactionDataSource.getTransactions(
          filter: TransactionFilter(
            startDate: rangeStart,
            endDate: rangeEnd,
            categoryId: categoryId,
          ),
        );

        var income = 0.0;
        var expense = 0.0;
        for (final transaction in transactions) {
          if (transaction.type == TransactionType.income) {
            income += transaction.amount;
          } else {
            expense += transaction.amount;
          }
        }

        return ReportTrendPoint(
          year: month.year,
          month: month.month,
          income: income,
          expense: expense,
        );
      }),
    );
  }

  List<ReportCategoryItem> _buildCategoryDistribution(
    List<Transaction> transactions,
  ) {
    final totals = <String, ReportCategoryItem>{};

    for (final transaction in transactions) {
      if (transaction.type != TransactionType.expense) {
        continue;
      }

      final category = transaction.category;
      final existing = totals[category.id];
      if (existing == null) {
        totals[category.id] = ReportCategoryItem(
          categoryId: category.id,
          categoryName: category.name,
          colorValue: category.colorValue,
          amount: transaction.amount,
        );
      } else {
        totals[category.id] = ReportCategoryItem(
          categoryId: category.id,
          categoryName: category.name,
          colorValue: category.colorValue,
          amount: existing.amount + transaction.amount,
        );
      }
    }

    return totals.values.toList()
      ..sort((first, second) => second.amount.compareTo(first.amount));
  }

  ({DateTime startDate, DateTime endDate}) _resolveDateRange(
    ReportFilter filter,
  ) {
    if (filter.startDate != null && filter.endDate != null) {
      return (startDate: filter.startDate!, endDate: filter.endDate!);
    }

    final preset = filter.dateRangePreset ?? filter.type.defaultDateRangePreset();
    return preset.resolve();
  }
}
