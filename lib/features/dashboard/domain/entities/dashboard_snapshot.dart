import 'package:equatable/equatable.dart';

import '../../../budgets/domain/entities/budget.dart';
import '../../../goals/domain/entities/savings_goal.dart';

class DashboardSnapshot extends Equatable {
  const DashboardSnapshot({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalSavings,
    required this.activeGoalsCount,
    required this.activeGoals,
    required this.budgetUsages,
    required this.monthlyTrend,
    required this.categoryDistribution,
    required this.hasTransactions,
    required this.hasAnyTransactions,
  });

  final double totalIncome;
  final double totalExpense;
  final double totalSavings;
  final int activeGoalsCount;
  final List<GoalProgress> activeGoals;
  final List<BudgetUsage> budgetUsages;
  final List<MonthlyTrendPoint> monthlyTrend;
  final List<CategoryDistributionItem> categoryDistribution;
  final bool hasTransactions;
  final bool hasAnyTransactions;

  double get netBalance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        totalSavings,
        activeGoalsCount,
        activeGoals,
        budgetUsages,
        monthlyTrend,
        categoryDistribution,
        hasTransactions,
        hasAnyTransactions,
      ];
}

class MonthlyTrendPoint extends Equatable {
  const MonthlyTrendPoint({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
  });

  final int year;
  final int month;
  final double income;
  final double expense;

  @override
  List<Object?> get props => [year, month, income, expense];
}

class CategoryDistributionItem extends Equatable {
  const CategoryDistributionItem({
    required this.categoryId,
    required this.categoryName,
    required this.colorValue,
    required this.amount,
  });

  final String categoryId;
  final String categoryName;
  final int colorValue;
  final double amount;

  @override
  List<Object?> get props => [categoryId, categoryName, colorValue, amount];
}

enum DashboardDateRangePreset {
  thisMonth,
  lastMonth,
  lastThreeMonths,
  lastSixMonths,
  thisYear,
}

extension DashboardDateRangePresetX on DashboardDateRangePreset {
  ({DateTime startDate, DateTime endDate}) resolve({DateTime? referenceDate}) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return switch (this) {
      DashboardDateRangePreset.thisMonth => (
          startDate: DateTime(now.year, now.month),
          endDate: DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999),
        ),
      DashboardDateRangePreset.lastMonth => (
          startDate: DateTime(now.year, now.month - 1),
          endDate: DateTime(now.year, now.month, 0, 23, 59, 59, 999),
        ),
      DashboardDateRangePreset.lastThreeMonths => (
          startDate: DateTime(now.year, now.month - 2),
          endDate: DateTime(today.year, today.month, today.day, 23, 59, 59, 999),
        ),
      DashboardDateRangePreset.lastSixMonths => (
          startDate: DateTime(now.year, now.month - 5),
          endDate: DateTime(today.year, today.month, today.day, 23, 59, 59, 999),
        ),
      DashboardDateRangePreset.thisYear => (
          startDate: DateTime(now.year),
          endDate: DateTime(today.year, today.month, today.day, 23, 59, 59, 999),
        ),
    };
  }
}
