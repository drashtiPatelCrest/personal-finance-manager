import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/export/domain/entities/export_labels.dart';
import 'package:personal_finance_manager/features/export/domain/entities/export_params.dart';
import 'package:personal_finance_manager/features/export/domain/repository/export_repository.dart';

void main() {
  group('ExportDataParams', () {
    test('supports value equality', () {
      const first = ExportDataParams(
        dataType: ExportDataType.transactions,
        format: ExportFormat.pdf,
        labels: ExportLabels(
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
        ),
      );

      const second = ExportDataParams(
        dataType: ExportDataType.transactions,
        format: ExportFormat.pdf,
        labels: ExportLabels(
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
        ),
      );

      expect(first, second);
    });
  });
}
