import '../../../dashboard/domain/entities/dashboard_snapshot.dart';
import '../../domain/entities/financial_report.dart';

DashboardSnapshot toDashboardChartSnapshot(FinancialReport report) {
  return DashboardSnapshot(
    totalIncome: report.summary.totalIncome,
    totalExpense: report.summary.totalExpense,
    totalSavings: report.summary.totalSavings,
    activeGoalsCount: report.summary.activeGoalCount,
    activeGoals: const [],
    budgetUsages: const [],
    monthlyTrend: report.monthlyTrend
        .map(
          (point) => MonthlyTrendPoint(
            year: point.year,
            month: point.month,
            income: point.income,
            expense: point.expense,
          ),
        )
        .toList(),
    categoryDistribution: report.categoryDistribution
        .map(
          (item) => CategoryDistributionItem(
            categoryId: item.categoryId,
            categoryName: item.categoryName,
            colorValue: item.colorValue,
            amount: item.amount,
          ),
        )
        .toList(),
    hasTransactions: report.hasData,
    hasAnyTransactions: report.hasData,
  );
}
