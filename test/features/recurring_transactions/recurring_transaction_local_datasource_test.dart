import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/categories/data/datasource/category_local_datasource.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart' as domain;
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';
import 'package:personal_finance_manager/features/recurring_transactions/data/datasource/recurring_transaction_local_datasource.dart';
import 'package:personal_finance_manager/features/recurring_transactions/domain/entities/recurring_transaction.dart';
import 'package:personal_finance_manager/features/recurring_transactions/domain/entities/recurring_transaction_error_code.dart';
import 'package:personal_finance_manager/features/recurring_transactions/domain/entities/recurring_transaction_params.dart';
import 'package:personal_finance_manager/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction.dart';

class _TestAppDatabase extends AppDatabase {
  _TestAppDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late _TestAppDatabase database;
  late CategoryLocalDataSource categoryDataSource;
  late TransactionLocalDataSource transactionDataSource;
  late RecurringTransactionLocalDataSource recurringDataSource;

  setUp(() async {
    database = _TestAppDatabase();
    categoryDataSource = CategoryLocalDataSource(database);
    transactionDataSource = TransactionLocalDataSource(database);
    recurringDataSource = RecurringTransactionLocalDataSource(
      database,
      transactionDataSource,
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<domain.Category> _createExpenseCategory() {
    return categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Rent',
        type: domain.CategoryType.expense,
        iconCode: 'home',
        colorValue: 0xFF1B6B4A,
      ),
    );
  }

  test('createRecurringTransaction stores and returns recurring item', () async {
    final category = await _createExpenseCategory();

    final recurring = await recurringDataSource.createRecurringTransaction(
      CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 1200,
        categoryId: category.id,
        frequency: RecurrenceFrequency.monthly,
        nextExecutionDate: DateTime(2026, 7, 1),
        note: 'Monthly rent',
      ),
    );

    expect(recurring.amount, 1200);
    expect(recurring.category.id, category.id);
    expect(recurring.frequency, RecurrenceFrequency.monthly);
    expect(recurring.isPaused, isFalse);
  });

  test('createRecurringTransaction rejects invalid amount', () async {
    final category = await _createExpenseCategory();

    expect(
      () => recurringDataSource.createRecurringTransaction(
        CreateRecurringTransactionParams(
          type: TransactionType.expense,
          amount: 0,
          categoryId: category.id,
          frequency: RecurrenceFrequency.monthly,
          nextExecutionDate: DateTime(2026, 7, 1),
          note: '',
        ),
      ),
      throwsA(
        isA<RecurringTransactionException>().having(
          (error) => error.code,
          'code',
          RecurringTransactionErrorCode.amountInvalid,
        ),
      ),
    );
  });

  test('pause and resume recurring transaction', () async {
    final category = await _createExpenseCategory();
    final recurring = await recurringDataSource.createRecurringTransaction(
      CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 50,
        categoryId: category.id,
        frequency: RecurrenceFrequency.weekly,
        nextExecutionDate: DateTime(2026, 7, 1),
        note: 'Subscription',
      ),
    );

    final paused =
        await recurringDataSource.pauseRecurringTransaction(recurring.id);
    expect(paused.isPaused, isTrue);

    final resumed =
        await recurringDataSource.resumeRecurringTransaction(recurring.id);
    expect(resumed.isPaused, isFalse);
  });

  test('processDueTransactions generates transactions and advances date', () async {
    final category = await _createExpenseCategory();
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final recurring = await recurringDataSource.createRecurringTransaction(
      CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 75,
        categoryId: category.id,
        frequency: RecurrenceFrequency.daily,
        nextExecutionDate: start,
        note: 'Daily coffee',
      ),
    );

    final generated = await recurringDataSource.processDueTransactions(
      referenceDate: start.add(const Duration(days: 2)),
    );

    expect(generated, 3);

    final transactions = await transactionDataSource.getTransactions();
    expect(transactions, hasLength(3));
    expect(
      transactions.every((transaction) => transaction.amount == 75),
      isTrue,
    );

    final updated =
        await recurringDataSource.getRecurringTransactionById(recurring.id);
    expect(updated?.nextExecutionDate, start.add(const Duration(days: 3)));
  });

  test('processDueTransactions skips paused recurring items', () async {
    final category = await _createExpenseCategory();
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final recurring = await recurringDataSource.createRecurringTransaction(
      CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 20,
        categoryId: category.id,
        frequency: RecurrenceFrequency.daily,
        nextExecutionDate: start,
        note: '',
      ),
    );

    await recurringDataSource.pauseRecurringTransaction(recurring.id);

    final generated = await recurringDataSource.processDueTransactions(
      referenceDate: start.add(const Duration(days: 1)),
    );

    expect(generated, 0);
    final transactions = await transactionDataSource.getTransactions();
    expect(transactions, isEmpty);
  });

  test('deleteRecurringTransaction removes an existing item', () async {
    final category = await _createExpenseCategory();
    final recurring = await recurringDataSource.createRecurringTransaction(
      CreateRecurringTransactionParams(
        type: TransactionType.expense,
        amount: 100,
        categoryId: category.id,
        frequency: RecurrenceFrequency.monthly,
        nextExecutionDate: DateTime(2026, 8, 1),
        note: '',
      ),
    );

    await recurringDataSource.deleteRecurringTransaction(recurring.id);

    final result =
        await recurringDataSource.getRecurringTransactionById(recurring.id);
    expect(result, isNull);
  });
}
