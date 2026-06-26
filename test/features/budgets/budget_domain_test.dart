import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget_error_code.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget_params.dart';

void main() {
  final startDate = DateTime(2026, 1, 1);
  final endDate = DateTime(2026, 1, 31);

  final budget = Budget(
    id: '1',
    name: 'Food',
    amount: 100,
    startDate: startDate,
    endDate: endDate,
  );

  group('CreateBudgetParams', () {
    test('supports value equality', () {
      final first = CreateBudgetParams(
        name: 'Monthly',
        amount: 1000,
        startDate: startDate,
        endDate: endDate,
      );
      final second = CreateBudgetParams(
        name: 'Monthly',
        amount: 1000,
        startDate: startDate,
        endDate: endDate,
      );

      expect(first, equals(second));
    });
  });

  group('BudgetUsage status', () {
    test('returns warning at 80 percent', () {
      final usage = BudgetUsage(
        budget: budget,
        spentAmount: 80,
        remainingAmount: 20,
        usagePercentage: 80,
      );

      expect(usage.status, BudgetStatus.warning);
    });

    test('returns exceeded at 100 percent', () {
      final usage = BudgetUsage(
        budget: budget,
        spentAmount: 120,
        remainingAmount: -20,
        usagePercentage: 120,
      );

      expect(usage.status, BudgetStatus.exceeded);
    });

    test('returns normal below 80 percent', () {
      final usage = BudgetUsage(
        budget: budget,
        spentAmount: 50,
        remainingAmount: 50,
        usagePercentage: 50,
      );

      expect(usage.status, BudgetStatus.normal);
    });
  });

  group('BudgetErrorCode', () {
    test('contains validation errors', () {
      expect(
        BudgetErrorCode.values,
        containsAll([
          BudgetErrorCode.dateRangeInvalid,
          BudgetErrorCode.categoryTypeMismatch,
          BudgetErrorCode.budgetNotFound,
        ]),
      );
    });
  });
}
