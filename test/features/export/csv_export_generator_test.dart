import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/export/data/datasource/csv_export_generator.dart';
import 'package:personal_finance_manager/features/export/domain/entities/export_labels.dart';
import 'package:personal_finance_manager/features/export/domain/entities/export_payload.dart';
import 'package:personal_finance_manager/features/export/domain/repository/export_repository.dart';
import 'package:personal_finance_manager/features/transactions/domain/entities/transaction.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart';

void main() {
  const labels = ExportLabels(
    appTitle: 'Export',
    summaryTitle: 'Summary',
    generatedAtLabel: 'Generated at',
    dateRangeLabel: 'Date range',
    allDatesLabel: 'All dates',
    transactionsTitle: 'Transactions',
    budgetsTitle: 'Budgets',
    goalsTitle: 'Goals',
    reportsTitle: 'Reports',
    incomeLabel: 'Income',
    expenseLabel: 'Expense',
    netBalanceLabel: 'Net balance',
    transactionCountLabel: 'Transactions',
    idLabel: 'ID',
    typeLabel: 'Type',
    amountLabel: 'Amount',
    dateLabel: 'Date',
    noteLabel: 'Note',
    categoryLabel: 'Category',
    nameLabel: 'Name',
    targetLabel: 'Target',
    currentLabel: 'Current',
    deadlineLabel: 'Deadline',
    statusLabel: 'Status',
    spentLabel: 'Spent',
    remainingLabel: 'Remaining',
    usageLabel: 'Usage',
    completionLabel: 'Completion',
    reportTypeMonthly: 'Monthly',
    reportTypeYearly: 'Yearly',
    reportTypeCategory: 'Category',
    reportTypeBudget: 'Budget',
    reportTypeGoal: 'Goal',
    chartIncomeExpenseTitle: 'Income vs Expense',
    chartCategoryTitle: 'Category',
    chartTrendTitle: 'Trend',
    incomeTypeLabel: 'Income',
    expenseTypeLabel: 'Expense',
  );

  test('generates transactions csv with header and row', () {
    final generator = CsvExportGenerator();
    final payload = ExportPayload(
      transactions: [
        Transaction(
          id: 'tx-1',
          type: TransactionType.expense,
          amount: 42.5,
          category: Category(
            id: 'cat-1',
            name: 'Food',
            type: CategoryType.expense,
            iconCode: 'restaurant',
            colorValue: 0xFFC62828,
          ),
          date: DateTime(2026, 6, 10),
          note: 'Lunch',
        ),
      ],
      transactionSummary: {'income': 0, 'expense': 42.5},
      budgetUsages: [],
      goalProgress: [],
      reports: [],
    );

    final bytes = generator.generate(
      dataType: ExportDataType.transactions,
      payload: payload,
      labels: labels,
    );
    final content = String.fromCharCodes(bytes);

    expect(content, contains('ID,Type,Amount,Date,Category,Note'));
    expect(content, contains('tx-1,expense,42.50,2026-06-10,Food,Lunch'));
  });
}
