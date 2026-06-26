import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction_error_code.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction_params.dart';

void main() {
  group('CreateTransactionParams', () {
    test('supports value equality', () {
      final date = DateTime(2026, 1, 15);
      final first = CreateTransactionParams(
        type: TransactionType.income,
        amount: 100,
        categoryId: 'cat-1',
        date: date,
        note: 'Bonus',
      );
      final second = CreateTransactionParams(
        type: TransactionType.income,
        amount: 100,
        categoryId: 'cat-1',
        date: date,
        note: 'Bonus',
      );

      expect(first, equals(second));
    });
  });

  group('TransactionFilter', () {
    test('supports optional filters', () {
      const filter = TransactionFilter(
        type: TransactionType.expense,
        categoryId: 'cat-1',
        query: 'coffee',
      );

      expect(filter.type, TransactionType.expense);
      expect(filter.categoryId, 'cat-1');
      expect(filter.query, 'coffee');
    });
  });

  group('TransactionErrorCode', () {
    test('contains validation errors', () {
      expect(
        TransactionErrorCode.values,
        containsAll([
          TransactionErrorCode.amountInvalid,
          TransactionErrorCode.categoryTypeMismatch,
          TransactionErrorCode.transactionNotFound,
        ]),
      );
    });
  });
}
