import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/recurring_transactions/domain/entities/recurrence_schedule.dart';
import 'package:personal_finance_manager/features/recurring_transactions/domain/entities/recurring_transaction.dart';
import 'package:personal_finance_manager/features/recurring_transactions/domain/entities/recurring_transaction_params.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction.dart';

void main() {
  group('CreateRecurringTransactionParams', () {
    test('supports value equality', () {
      final first = CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 100,
        categoryId: 'cat-1',
        frequency: RecurrenceFrequency.monthly,
        nextExecutionDate: DateTime(2026, 6, 1),
        note: 'Rent',
      );
      final second = CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 100,
        categoryId: 'cat-1',
        frequency: RecurrenceFrequency.monthly,
        nextExecutionDate: DateTime(2026, 6, 1),
        note: 'Rent',
      );

      expect(first, equals(second));
    });
  });

  group('RecurrenceSchedule', () {
    test('calculates daily next execution', () {
      final next = RecurrenceSchedule.calculateNextExecution(
        frequency: RecurrenceFrequency.daily,
        from: DateTime(2026, 6, 1),
      );

      expect(next, DateTime(2026, 6, 2));
    });

    test('calculates weekly next execution', () {
      final next = RecurrenceSchedule.calculateNextExecution(
        frequency: RecurrenceFrequency.weekly,
        from: DateTime(2026, 6, 1),
      );

      expect(next, DateTime(2026, 6, 8));
    });

    test('calculates monthly next execution', () {
      final next = RecurrenceSchedule.calculateNextExecution(
        frequency: RecurrenceFrequency.monthly,
        from: DateTime(2026, 1, 31),
      );

      expect(next, DateTime(2026, 2, 28));
    });

    test('advances until future date', () {
      final next = RecurrenceSchedule.advanceUntilFuture(
        frequency: RecurrenceFrequency.monthly,
        nextExecution: DateTime(2026, 1, 1),
        referenceDate: DateTime(2026, 6, 15),
      );

      expect(next.isBefore(DateTime(2026, 6, 15)), isFalse);
    });

    test('detects due execution', () {
      final isDue = RecurrenceSchedule.isDue(
        nextExecution: DateTime(2026, 6, 1),
        referenceDate: DateTime(2026, 6, 1, 12),
      );

      expect(isDue, isTrue);
    });
  });
}
