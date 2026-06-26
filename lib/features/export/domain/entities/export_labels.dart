import 'package:equatable/equatable.dart';

class ExportLabels extends Equatable {
  const ExportLabels({
    required this.appTitle,
    required this.summaryTitle,
    required this.generatedAtLabel,
    required this.dateRangeLabel,
    required this.allDatesLabel,
    required this.transactionsTitle,
    required this.budgetsTitle,
    required this.goalsTitle,
    required this.reportsTitle,
    required this.incomeLabel,
    required this.expenseLabel,
    required this.netBalanceLabel,
    required this.transactionCountLabel,
    required this.idLabel,
    required this.typeLabel,
    required this.amountLabel,
    required this.dateLabel,
    required this.noteLabel,
    required this.categoryLabel,
    required this.nameLabel,
    required this.targetLabel,
    required this.currentLabel,
    required this.deadlineLabel,
    required this.statusLabel,
    required this.spentLabel,
    required this.remainingLabel,
    required this.usageLabel,
    required this.completionLabel,
    required this.reportTypeMonthly,
    required this.reportTypeYearly,
    required this.reportTypeCategory,
    required this.reportTypeBudget,
    required this.reportTypeGoal,
    required this.chartIncomeExpenseTitle,
    required this.chartCategoryTitle,
    required this.chartTrendTitle,
    required this.incomeTypeLabel,
    required this.expenseTypeLabel,
  });

  final String appTitle;
  final String summaryTitle;
  final String generatedAtLabel;
  final String dateRangeLabel;
  final String allDatesLabel;
  final String transactionsTitle;
  final String budgetsTitle;
  final String goalsTitle;
  final String reportsTitle;
  final String incomeLabel;
  final String expenseLabel;
  final String netBalanceLabel;
  final String transactionCountLabel;
  final String idLabel;
  final String typeLabel;
  final String amountLabel;
  final String dateLabel;
  final String noteLabel;
  final String categoryLabel;
  final String nameLabel;
  final String targetLabel;
  final String currentLabel;
  final String deadlineLabel;
  final String statusLabel;
  final String spentLabel;
  final String remainingLabel;
  final String usageLabel;
  final String completionLabel;
  final String reportTypeMonthly;
  final String reportTypeYearly;
  final String reportTypeCategory;
  final String reportTypeBudget;
  final String reportTypeGoal;
  final String chartIncomeExpenseTitle;
  final String chartCategoryTitle;
  final String chartTrendTitle;
  final String incomeTypeLabel;
  final String expenseTypeLabel;

  @override
  List<Object?> get props => [
        appTitle,
        summaryTitle,
        generatedAtLabel,
        dateRangeLabel,
        allDatesLabel,
        transactionsTitle,
        budgetsTitle,
        goalsTitle,
        reportsTitle,
        incomeLabel,
        expenseLabel,
        netBalanceLabel,
        transactionCountLabel,
        idLabel,
        typeLabel,
        amountLabel,
        dateLabel,
        noteLabel,
        categoryLabel,
        nameLabel,
        targetLabel,
        currentLabel,
        deadlineLabel,
        statusLabel,
        spentLabel,
        remainingLabel,
        usageLabel,
        completionLabel,
        reportTypeMonthly,
        reportTypeYearly,
        reportTypeCategory,
        reportTypeBudget,
        reportTypeGoal,
        chartIncomeExpenseTitle,
        chartCategoryTitle,
        chartTrendTitle,
        incomeTypeLabel,
        expenseTypeLabel,
      ];
}
