import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/export_error_code.dart';
import '../../domain/entities/export_labels.dart';
import '../../domain/repository/export_repository.dart';

extension ExportErrorLocalization on ExportErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      ExportErrorCode.unknown => l10n.exportErrorUnknown,
      ExportErrorCode.noData => l10n.exportErrorNoData,
      ExportErrorCode.fileWriteFailed => l10n.exportErrorFileWrite,
    };
  }
}

extension ExportDataTypeLocalization on ExportDataType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      ExportDataType.transactions => l10n.exportDataTypeTransactions,
      ExportDataType.budgets => l10n.exportDataTypeBudgets,
      ExportDataType.goals => l10n.exportDataTypeGoals,
      ExportDataType.reports => l10n.exportDataTypeReports,
    };
  }

  String description(AppLocalizations l10n) {
    return switch (this) {
      ExportDataType.transactions => l10n.exportDataTypeTransactionsDescription,
      ExportDataType.budgets => l10n.exportDataTypeBudgetsDescription,
      ExportDataType.goals => l10n.exportDataTypeGoalsDescription,
      ExportDataType.reports => l10n.exportDataTypeReportsDescription,
    };
  }
}

extension ExportFormatLocalization on ExportFormat {
  String label(AppLocalizations l10n) {
    return switch (this) {
      ExportFormat.pdf => l10n.exportFormatPdf,
      ExportFormat.csv => l10n.exportFormatCsv,
    };
  }
}

class ExportLocalizationBundle {
  static ExportLabels fromL10n(AppLocalizations l10n) {
    return ExportLabels(
      appTitle: l10n.exportTitle,
      summaryTitle: l10n.exportSummaryTitle,
      generatedAtLabel: l10n.exportGeneratedAtLabel,
      dateRangeLabel: l10n.exportDateRangeLabel,
      allDatesLabel: l10n.exportAllDatesLabel,
      transactionsTitle: l10n.exportDataTypeTransactions,
      budgetsTitle: l10n.exportDataTypeBudgets,
      goalsTitle: l10n.exportDataTypeGoals,
      reportsTitle: l10n.exportDataTypeReports,
      incomeLabel: l10n.exportIncomeLabel,
      expenseLabel: l10n.exportExpenseLabel,
      netBalanceLabel: l10n.exportNetBalanceLabel,
      transactionCountLabel: l10n.exportTransactionCountLabel,
      idLabel: l10n.exportIdLabel,
      typeLabel: l10n.exportTypeLabel,
      amountLabel: l10n.exportAmountLabel,
      dateLabel: l10n.exportDateLabel,
      noteLabel: l10n.exportNoteLabel,
      categoryLabel: l10n.exportCategoryLabel,
      nameLabel: l10n.exportNameLabel,
      targetLabel: l10n.exportTargetLabel,
      currentLabel: l10n.exportCurrentLabel,
      deadlineLabel: l10n.exportDeadlineLabel,
      statusLabel: l10n.exportStatusLabel,
      spentLabel: l10n.exportSpentLabel,
      remainingLabel: l10n.exportRemainingLabel,
      usageLabel: l10n.exportUsageLabel,
      completionLabel: l10n.exportCompletionLabel,
      reportTypeMonthly: l10n.reportTypeMonthly,
      reportTypeYearly: l10n.reportTypeYearly,
      reportTypeCategory: l10n.reportTypeCategory,
      reportTypeBudget: l10n.reportTypeBudget,
      reportTypeGoal: l10n.reportTypeGoal,
      chartIncomeExpenseTitle: l10n.dashboardIncomeExpenseChartTitle,
      chartCategoryTitle: l10n.dashboardCategoryChartTitle,
      chartTrendTitle: l10n.dashboardMonthlyTrendChartTitle,
      incomeTypeLabel: l10n.transactionSummaryIncome,
      expenseTypeLabel: l10n.transactionSummaryExpense,
    );
  }
}
