import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/budgets/data/datasource/budget_local_datasource.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget_params.dart';
import 'package:personal_finance_manager/features/categories/data/datasource/category_local_datasource.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart' as domain;
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';
import 'package:personal_finance_manager/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:personal_finance_manager/features/dashboard/domain/entities/dashboard_params.dart';
import 'package:personal_finance_manager/features/goals/data/datasource/goal_local_datasource.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/goal_params.dart';
import 'package:personal_finance_manager/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction_params.dart';

class _TestAppDatabase extends AppDatabase {
  _TestAppDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late _TestAppDatabase database;
  late CategoryLocalDataSource categoryDataSource;
  late TransactionLocalDataSource transactionDataSource;
  late BudgetLocalDataSource budgetDataSource;
  late GoalLocalDataSource goalDataSource;
  late DashboardLocalDataSource dashboardDataSource;

  setUp(() async {
    database = _TestAppDatabase();
    categoryDataSource = CategoryLocalDataSource(database);
    transactionDataSource = TransactionLocalDataSource(database);
    budgetDataSource = BudgetLocalDataSource(database);
    goalDataSource = GoalLocalDataSource(database);
    dashboardDataSource = DashboardLocalDataSource(
      transactionDataSource,
      budgetDataSource,
      goalDataSource,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('getDashboardData aggregates income, expense, and savings', () async {
    final incomeCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: domain.CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );
    final expenseCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: domain.CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFFC62828,
      ),
    );

    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.income,
        amount: 3000,
        categoryId: incomeCategory.id,
        date: DateTime(2026, 6, 10),
      ),
    );
    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 500,
        categoryId: expenseCategory.id,
        date: DateTime(2026, 6, 12),
      ),
    );

    await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'Monthly',
        amount: 2000,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30),
      ),
    );

    await goalDataSource.createGoal(
      CreateGoalParams(
        name: 'Vacation',
        targetAmount: 5000,
        deadline: DateTime(2026, 12, 31),
      ),
    );
    final goal = (await goalDataSource.getGoals()).first;
    await goalDataSource.addContribution(
      AddContributionParams(
        goalId: goal.id,
        amount: 1000,
        date: DateTime(2026, 6, 5),
      ),
    );

    final snapshot = await dashboardDataSource.getDashboardData(
      GetDashboardParams(
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30, 23, 59, 59, 999),
      ),
    );

    expect(snapshot.totalIncome, 3000);
    expect(snapshot.totalExpense, 500);
    expect(snapshot.totalSavings, 1000);
    expect(snapshot.activeGoalsCount, 1);
    expect(snapshot.budgetUsages, hasLength(1));
    expect(snapshot.categoryDistribution, hasLength(1));
    expect(snapshot.categoryDistribution.first.categoryName, 'Food');
    expect(snapshot.hasTransactions, isTrue);
    expect(snapshot.hasAnyTransactions, isTrue);
  });

  test('getDashboardData returns empty snapshot when no data exists', () async {
    final snapshot = await dashboardDataSource.getDashboardData(
      GetDashboardParams(
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30, 23, 59, 59, 999),
      ),
    );

    expect(snapshot.totalIncome, 0);
    expect(snapshot.totalExpense, 0);
    expect(snapshot.hasTransactions, isFalse);
    expect(snapshot.hasAnyTransactions, isFalse);
    expect(snapshot.categoryDistribution, isEmpty);
  });

  test('getDashboardData detects transactions outside selected range', () async {
    final incomeCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: domain.CategoryType.income,
        iconCode: 'payments',
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

    final snapshot = await dashboardDataSource.getDashboardData(
      GetDashboardParams(
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30, 23, 59, 59, 999),
      ),
    );

    expect(snapshot.hasTransactions, isFalse);
    expect(snapshot.hasAnyTransactions, isTrue);
  });
}
