import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/budgets/data/datasource/budget_local_datasource.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget_error_code.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget_params.dart';
import 'package:personal_finance_manager/features/categories/data/datasource/category_local_datasource.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';

class _TestAppDatabase extends AppDatabase {
  _TestAppDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late _TestAppDatabase database;
  late CategoryLocalDataSource categoryDataSource;
  late BudgetLocalDataSource budgetDataSource;

  setUp(() async {
    database = _TestAppDatabase();
    categoryDataSource = CategoryLocalDataSource(database);
    budgetDataSource = BudgetLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('createBudget stores overall budget', () async {
    final budget = await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Monthly Spending',
        amount: 2000,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    );

    expect(budget.name, 'Monthly Spending');
    expect(budget.type, BudgetType.overall);
    expect(budget.categoryId, isNull);
  });

  test('createBudget stores category budget', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    final budget = await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Food Budget',
        amount: 500,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        categoryId: category.id,
      ),
    );

    expect(budget.type, BudgetType.category);
    expect(budget.categoryId, category.id);
  });

  test('createBudget rejects invalid date range', () async {
    expect(
      () => budgetDataSource.createBudget(
        CreateBudgetParams(
          name: 'Invalid',
          amount: 100,
          startDate: DateTime(2026, 2, 1),
          endDate: DateTime(2026, 1, 1),
        ),
      ),
      throwsA(
        isA<BudgetException>().having(
          (error) => error.code,
          'code',
          BudgetErrorCode.dateRangeInvalid,
        ),
      ),
    );
  });

  test('createBudget rejects income category', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );

    expect(
      () => budgetDataSource.createBudget(
        CreateBudgetParams(
          name: 'Invalid',
          amount: 100,
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
          categoryId: category.id,
        ),
      ),
      throwsA(
        isA<BudgetException>().having(
          (error) => error.code,
          'code',
          BudgetErrorCode.categoryTypeMismatch,
        ),
      ),
    );
  });

  test('getBudgetUsage calculates spent, remaining, and percentage', () async {
    final category = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );

    final budget = await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Food Budget',
        amount: 200,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        categoryId: category.id,
      ),
    );

    await database.into(database.transactions).insert(
          TransactionsCompanion.insert(
            id: 'tx-1',
            categoryId: category.id,
            type: 'expense',
            amount: 80,
            date: DateTime(2026, 1, 10),
          ),
        );
    await database.into(database.transactions).insert(
          TransactionsCompanion.insert(
            id: 'tx-2',
            categoryId: category.id,
            type: 'expense',
            amount: 100,
            date: DateTime(2026, 1, 15),
          ),
        );

    final usage = await budgetDataSource.getBudgetUsage(budget.id);

    expect(usage.spentAmount, 180);
    expect(usage.remainingAmount, 20);
    expect(usage.usagePercentage, 90);
    expect(usage.status, BudgetStatus.warning);
    expect(usage.categoryName, 'Food');
  });

  test('getBudgetUsage for overall budget sums all expenses', () async {
    final foodCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF1B6B4A,
      ),
    );
    final transportCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Transport',
        type: CategoryType.expense,
        iconCode: 'directions_car',
        colorValue: 0xFF1B6B4A,
      ),
    );

    final budget = await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Overall',
        amount: 1000,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    );

    await database.into(database.transactions).insert(
          TransactionsCompanion.insert(
            id: 'tx-1',
            categoryId: foodCategory.id,
            type: 'expense',
            amount: 300,
            date: DateTime(2026, 1, 5),
          ),
        );
    await database.into(database.transactions).insert(
          TransactionsCompanion.insert(
            id: 'tx-2',
            categoryId: transportCategory.id,
            type: 'expense',
            amount: 800,
            date: DateTime(2026, 1, 8),
          ),
        );

    final usage = await budgetDataSource.getBudgetUsage(budget.id);

    expect(usage.spentAmount, 1100);
    expect(usage.remainingAmount, -100);
    expect(usage.usagePercentage, closeTo(110, 0.001));
    expect(usage.status, BudgetStatus.exceeded);
  });

  test('updateBudget updates fields', () async {
    final budget = await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Monthly',
        amount: 500,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    );

    final updated = await budgetDataSource.updateBudget(
      UpdateBudgetParams(
        id: budget.id,
        name: 'Updated Monthly',
        amount: 600,
        startDate: DateTime(2026, 2, 1),
        endDate: DateTime(2026, 2, 28),
      ),
    );

    expect(updated.name, 'Updated Monthly');
    expect(updated.amount, 600);
  });

  test('createBudget rejects duplicate names', () async {
    await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Monthly',
        amount: 500,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    );

    expect(
      () => budgetDataSource.createBudget(
        CreateBudgetParams(
          name: 'Monthly',
          amount: 600,
          startDate: DateTime(2026, 2, 1),
          endDate: DateTime(2026, 2, 28),
        ),
      ),
      throwsA(
        isA<BudgetException>().having(
          (error) => error.code,
          'code',
          BudgetErrorCode.duplicateName,
        ),
      ),
    );
  });

  test('deleteBudget removes an existing budget', () async {
    final budget = await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Temp',
        amount: 100,
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    );

    await budgetDataSource.deleteBudget(budget.id);

    final result = await budgetDataSource.getBudgetById(budget.id);
    expect(result, isNull);
  });
}
