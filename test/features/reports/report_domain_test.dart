import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/reports/domain/entities/financial_report.dart';

void main() {
  group('ReportDateRangePreset', () {
    test('resolves this month range', () {
      final range = ReportDateRangePreset.thisMonth.resolve(
        referenceDate: DateTime(2026, 6, 15),
      );

      expect(range.startDate, DateTime(2026, 6));
      expect(range.endDate.day, 30);
    });

    test('resolves this year range', () {
      final range = ReportDateRangePreset.thisYear.resolve(
        referenceDate: DateTime(2026, 6, 15),
      );

      expect(range.startDate, DateTime(2026));
      expect(range.endDate.month, 6);
      expect(range.endDate.day, 15);
    });
  });

  group('ReportSummary', () {
    test('calculates net balance', () {
      const summary = ReportSummary(
        totalIncome: 4000,
        totalExpense: 2500,
        transactionCount: 10,
      );

      expect(summary.netBalance, 1500);
    });
  });

  group('ReportType', () {
    test('monthly supports category filter', () {
      expect(ReportType.monthly.supportsCategoryFilter(), isTrue);
      expect(ReportType.budget.supportsCategoryFilter(), isFalse);
    });

    test('goal does not support date range filter', () {
      expect(ReportType.goal.supportsDateRangeFilter(), isFalse);
      expect(ReportType.yearly.supportsDateRangeFilter(), isTrue);
    });

    test('defaults date range preset per type', () {
      expect(
        ReportType.yearly.defaultDateRangePreset(),
        ReportDateRangePreset.thisYear,
      );
      expect(
        ReportType.category.defaultDateRangePreset(),
        ReportDateRangePreset.lastThreeMonths,
      );
    });
  });
}
