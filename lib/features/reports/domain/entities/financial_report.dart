import 'package:equatable/equatable.dart';

import '../../../budgets/domain/entities/budget.dart';
import '../../../goals/domain/entities/savings_goal.dart';

enum ReportType { monthly, yearly, category, budget, goal }

enum ReportDateRangePreset {
  thisMonth,
  lastMonth,
  lastThreeMonths,
  lastSixMonths,
  thisYear,
}

class ReportSummary extends Equatable {
  const ReportSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
    this.totalSavings = 0,
    this.totalBudgets = 0,
    this.exceededBudgetCount = 0,
    this.warningBudgetCount = 0,
    this.activeGoalCount = 0,
    this.completedGoalCount = 0,
  });

  final double totalIncome;
  final double totalExpense;
  final int transactionCount;
  final double totalSavings;
  final int totalBudgets;
  final int exceededBudgetCount;
  final int warningBudgetCount;
  final int activeGoalCount;
  final int completedGoalCount;

  double get netBalance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        transactionCount,
        totalSavings,
        totalBudgets,
        exceededBudgetCount,
        warningBudgetCount,
        activeGoalCount,
        completedGoalCount,
      ];
}

class ReportTrendPoint extends Equatable {
  const ReportTrendPoint({
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

class ReportCategoryItem extends Equatable {
  const ReportCategoryItem({
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

class FinancialReport extends Equatable {
  const FinancialReport({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.monthlyTrend,
    required this.categoryDistribution,
    required this.budgetUsages,
    required this.goalProgress,
    required this.hasData,
    this.categoryId,
    this.categoryName,
  });

  final ReportType type;
  final DateTime startDate;
  final DateTime endDate;
  final ReportSummary summary;
  final List<ReportTrendPoint> monthlyTrend;
  final List<ReportCategoryItem> categoryDistribution;
  final List<BudgetUsage> budgetUsages;
  final List<GoalProgress> goalProgress;
  final bool hasData;
  final String? categoryId;
  final String? categoryName;

  @override
  List<Object?> get props => [
        type,
        startDate,
        endDate,
        summary,
        monthlyTrend,
        categoryDistribution,
        budgetUsages,
        goalProgress,
        hasData,
        categoryId,
        categoryName,
      ];
}

class ReportFilter extends Equatable {
  const ReportFilter({
    required this.type,
    this.startDate,
    this.endDate,
    this.categoryId,
    this.dateRangePreset,
  });

  final ReportType type;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? categoryId;
  final ReportDateRangePreset? dateRangePreset;

  @override
  List<Object?> get props => [
        type,
        startDate,
        endDate,
        categoryId,
        dateRangePreset,
      ];
}

extension ReportDateRangePresetX on ReportDateRangePreset {
  ({DateTime startDate, DateTime endDate}) resolve({DateTime? referenceDate}) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return switch (this) {
      ReportDateRangePreset.thisMonth => (
          startDate: DateTime(now.year, now.month),
          endDate: DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999),
        ),
      ReportDateRangePreset.lastMonth => (
          startDate: DateTime(now.year, now.month - 1),
          endDate: DateTime(now.year, now.month, 0, 23, 59, 59, 999),
        ),
      ReportDateRangePreset.lastThreeMonths => (
          startDate: DateTime(now.year, now.month - 2),
          endDate: DateTime(today.year, today.month, today.day, 23, 59, 59, 999),
        ),
      ReportDateRangePreset.lastSixMonths => (
          startDate: DateTime(now.year, now.month - 5),
          endDate: DateTime(today.year, today.month, today.day, 23, 59, 59, 999),
        ),
      ReportDateRangePreset.thisYear => (
          startDate: DateTime(now.year),
          endDate: DateTime(today.year, today.month, today.day, 23, 59, 59, 999),
        ),
    };
  }
}

extension ReportTypeDefaults on ReportType {
  ReportDateRangePreset defaultDateRangePreset() {
    return switch (this) {
      ReportType.monthly => ReportDateRangePreset.thisMonth,
      ReportType.yearly => ReportDateRangePreset.thisYear,
      ReportType.category => ReportDateRangePreset.lastThreeMonths,
      ReportType.budget => ReportDateRangePreset.thisMonth,
      ReportType.goal => ReportDateRangePreset.thisYear,
    };
  }

  bool supportsCategoryFilter() {
    return switch (this) {
      ReportType.monthly || ReportType.yearly || ReportType.category => true,
      ReportType.budget || ReportType.goal => false,
    };
  }

  bool supportsDateRangeFilter() {
    return switch (this) {
      ReportType.goal => false,
      _ => true,
    };
  }
}
