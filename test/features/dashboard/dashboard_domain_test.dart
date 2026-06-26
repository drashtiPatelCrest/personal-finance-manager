import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/dashboard/domain/entities/dashboard_snapshot.dart';

void main() {
  group('DashboardDateRangePreset', () {
    test('resolves this month range', () {
      final range = DashboardDateRangePreset.thisMonth.resolve(
        referenceDate: DateTime(2026, 6, 15),
      );

      expect(range.startDate, DateTime(2026, 6));
      expect(range.endDate.day, 30);
    });

    test('resolves last month range', () {
      final range = DashboardDateRangePreset.lastMonth.resolve(
        referenceDate: DateTime(2026, 6, 15),
      );

      expect(range.startDate, DateTime(2026, 5));
      expect(range.endDate.month, 5);
    });
  });

  group('DashboardSnapshot', () {
    test('calculates net balance', () {
      const snapshot = DashboardSnapshot(
        totalIncome: 5000,
        totalExpense: 3000,
        totalSavings: 1200,
        activeGoalsCount: 1,
        activeGoals: [],
        budgetUsages: [],
        monthlyTrend: [],
        categoryDistribution: [],
        hasTransactions: true,
        hasAnyTransactions: true,
      );

      expect(snapshot.netBalance, 2000);
    });
  });
}
