import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/categories/data/datasource/category_local_datasource.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';
import 'package:personal_finance_manager/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction_error_code.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction_params.dart';

class _TestAppDatabase extends AppDatabase {
  _TestAppDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late _TestAppDatabase database;
  late CategoryLocalDataSource categoryDataSource;
  late TransactionLocalDataSource transactionDataSource;

  setUp(() async {
    database = _TestAppDatabase();
    categoryDataSource = CategoryLocalDataSource(database);
    transactionDataSource = TransactionLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('createTransaction stores and returns a transaction', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );

    final transaction = await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.income,
        amount: 2500,
        categoryId: category.id,
        date: DateTime(2026, 1, 15),
        note: 'Monthly salary',
      ),
    );

    expect(transaction.amount, 2500);
    expect(transaction.type, TransactionType.income);
    expect(transaction.category.id, category.id);
    expect(transaction.note, 'Monthly salary');
  });

  test('createTransaction rejects invalid amount', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    expect(
      () => transactionDataSource.createTransaction(
        CreateTransactionParams(
          type: TransactionType.expense,
          amount: 0,
          categoryId: category.id,
          date: DateTime.now(),
        ),
      ),
      throwsA(
        isA<TransactionException>().having(
          (error) => error.code,
          'code',
          TransactionErrorCode.amountInvalid,
        ),
      ),
    );
  });

  test('createTransaction rejects category type mismatch', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );

    expect(
      () => transactionDataSource.createTransaction(
        CreateTransactionParams(
          type: TransactionType.expense,
          amount: 100,
          categoryId: category.id,
          date: DateTime.now(),
        ),
      ),
      throwsA(
        isA<TransactionException>().having(
          (error) => error.code,
          'code',
          TransactionErrorCode.categoryTypeMismatch,
        ),
      ),
    );
  });

  test('getTransactions filters by type and date range', () async {
    final incomeCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );
    final expenseCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.income,
        amount: 1000,
        categoryId: incomeCategory.id,
        date: DateTime(2026, 1, 10),
      ),
    );
    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 50,
        categoryId: expenseCategory.id,
        date: DateTime(2026, 1, 12),
      ),
    );

    final incomeTransactions = await transactionDataSource.getTransactions(
      filter: const TransactionFilter(type: TransactionType.income),
    );
    final rangedTransactions = await transactionDataSource.getTransactions(
      filter: TransactionFilter(
        startDate: DateTime(2026, 1, 11),
        endDate: DateTime(2026, 1, 31),
      ),
    );

    expect(incomeTransactions, hasLength(1));
    expect(rangedTransactions, hasLength(1));
    expect(rangedTransactions.first.type, TransactionType.expense);
  });

  test('getSummary calculates income, expense, and net totals', () async {
    final incomeCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );
    final expenseCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.income,
        amount: 1000,
        categoryId: incomeCategory.id,
        date: DateTime(2026, 2, 1),
      ),
    );
    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 300,
        categoryId: expenseCategory.id,
        date: DateTime(2026, 2, 5),
      ),
    );

    final summary = await transactionDataSource.getSummary(
      startDate: DateTime(2026, 2, 1),
      endDate: DateTime(2026, 2, 28),
    );

    expect(summary['income'], 1000);
    expect(summary['expense'], 300);
    expect(summary['net'], 700);
  });

  test('deleteTransaction removes an existing transaction', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    final transaction = await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 25,
        categoryId: category.id,
        date: DateTime.now(),
      ),
    );

    await transactionDataSource.deleteTransaction(transaction.id);

    final result = await transactionDataSource.getTransactionById(transaction.id);
    expect(result, isNull);
  });

  test('updateTransaction updates fields', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    final transaction = await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 25,
        categoryId: category.id,
        date: DateTime(2026, 3, 1),
        note: 'Lunch',
      ),
    );

    final updated = await transactionDataSource.updateTransaction(
      UpdateTransactionParams(
        id: transaction.id,
        type: TransactionType.expense,
        amount: 40,
        categoryId: category.id,
        date: DateTime(2026, 3, 2),
        note: 'Dinner',
      ),
    );

    expect(updated.amount, 40);
    expect(updated.note, 'Dinner');
    expect(updated.date, DateTime(2026, 3, 2));
  });

  test('getTransactions filters by search query', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Coffee',
        type: CategoryType.expense,
        iconCode: 'local_cafe',
        colorValue: 0xFF1B6B4A,
      ),
    );

    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 5,
        categoryId: category.id,
        date: DateTime.now(),
        note: 'Morning latte',
      ),
    );
    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 12,
        categoryId: category.id,
        date: DateTime.now(),
        note: 'Grocery run',
      ),
    );

    final results = await transactionDataSource.getTransactions(
      filter: const TransactionFilter(query: 'latte'),
    );

    expect(results, hasLength(1));
    expect(results.first.note, 'Morning latte');
  });

  test('createTransaction rejects note that is too long', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    expect(
      () => transactionDataSource.createTransaction(
        CreateTransactionParams(
          type: TransactionType.expense,
          amount: 10,
          categoryId: category.id,
          date: DateTime.now(),
          note: 'a' * 501,
        ),
      ),
      throwsA(
        isA<TransactionException>().having(
          (error) => error.code,
          'code',
          TransactionErrorCode.noteTooLong,
        ),
      ),
    );
  });
}
