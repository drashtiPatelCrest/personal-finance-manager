import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/budgets/data/datasource/budget_local_datasource.dart';
import 'package:personal_finance_manager/features/budgets/domain/entities/budget_params.dart';
import 'package:personal_finance_manager/features/categories/data/datasource/category_local_datasource.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart' as domain;
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';
import 'package:personal_finance_manager/features/goals/data/datasource/goal_local_datasource.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/goal_params.dart';
import 'package:personal_finance_manager/features/reports/data/datasource/report_local_datasource.dart';
import 'package:personal_finance_manager/features/reports/domain/entities/financial_report.dart';
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
  late ReportLocalDataSource reportDataSource;

  setUp(() async {
    database = _TestAppDatabase();
    categoryDataSource = CategoryLocalDataSource(database);
    transactionDataSource = TransactionLocalDataSource(database);
    budgetDataSource = BudgetLocalDataSource(database);
    goalDataSource = GoalLocalDataSource(database);
    reportDataSource = ReportLocalDataSource(
      transactionDataSource,
      budgetDataSource,
      goalDataSource,
      categoryDataSource,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('generateReport builds monthly transaction report', () async {
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
        amount: 2000,
        categoryId: incomeCategory.id,
        date: DateTime(2026, 6, 5),
      ),
    );
    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 400,
        categoryId: expenseCategory.id,
        date: DateTime(2026, 6, 10),
      ),
    );

    final report = await reportDataSource.generateReport(
      ReportFilter(
        type: ReportType.monthly,
        dateRangePreset: ReportDateRangePreset.thisMonth,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30, 23, 59, 59, 999),
      ),
    );

    expect(report.type, ReportType.monthly);
    expect(report.summary.totalIncome, 2000);
    expect(report.summary.totalExpense, 400);
    expect(report.summary.transactionCount, 2);
    expect(report.categoryDistribution, hasLength(1));
    expect(report.hasData, isTrue);
  });

  test('generateReport builds budget analysis report', () async {
    await budgetDataSource.createBudget(
      CreateBudgetParams(
        name: 'June Budget',
        amount: 1000,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30),
      ),
    );

    final report = await reportDataSource.generateReport(
      ReportFilter(
        type: ReportType.budget,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30, 23, 59, 59, 999),
      ),
    );

    expect(report.type, ReportType.budget);
    expect(report.budgetUsages, hasLength(1));
    expect(report.summary.totalBudgets, 1);
    expect(report.hasData, isTrue);
  });

  test('generateReport builds goal progress report', () async {
    await goalDataSource.createGoal(
      CreateGoalParams(
        name: 'Emergency Fund',
        targetAmount: 5000,
        deadline: DateTime(2026, 12, 31),
      ),
    );
    final goal = (await goalDataSource.getGoals()).first;
    await goalDataSource.addContribution(
      AddContributionParams(
        goalId: goal.id,
        amount: 500,
        date: DateTime(2026, 6, 1),
      ),
    );

    final report = await reportDataSource.generateReport(
      const ReportFilter(type: ReportType.goal),
    );

    expect(report.type, ReportType.goal);
    expect(report.goalProgress, hasLength(1));
    expect(report.summary.totalSavings, 500);
    expect(report.summary.activeGoalCount, 1);
    expect(report.hasData, isTrue);
  });

  test('generateReport filters transactions by category', () async {
    final foodCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Food',
        type: domain.CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFFC62828,
      ),
    );
    final travelCategory = await categoryDataSource.createCategory(
      const CreateCategoryParams(
        name: 'Travel',
        type: domain.CategoryType.expense,
        iconCode: 'flight',
        colorValue: 0xFF1565C0,
      ),
    );

    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 100,
        categoryId: foodCategory.id,
        date: DateTime(2026, 6, 5),
      ),
    );
    await transactionDataSource.createTransaction(
      CreateTransactionParams(
        type: TransactionType.expense,
        amount: 300,
        categoryId: travelCategory.id,
        date: DateTime(2026, 6, 8),
      ),
    );

    final report = await reportDataSource.generateReport(
      ReportFilter(
        type: ReportType.category,
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 30, 23, 59, 59, 999),
        categoryId: foodCategory.id,
      ),
    );

    expect(report.summary.totalExpense, 100);
    expect(report.summary.transactionCount, 1);
    expect(report.categoryName, 'Food');
  });
}
