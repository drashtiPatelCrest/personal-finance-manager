import 'package:equatable/equatable.dart';

import '../../../budgets/domain/entities/budget.dart';
import '../../../goals/domain/entities/savings_goal.dart';
import '../../../reports/domain/entities/financial_report.dart';
import '../../../transactions/domain/entities/transaction.dart';

class ExportPayload extends Equatable {
  const ExportPayload({
    required this.transactions,
    required this.transactionSummary,
    required this.budgetUsages,
    required this.goalProgress,
    required this.reports,
    this.startDate,
    this.endDate,
  });

  final List<Transaction> transactions;
  final Map<String, num> transactionSummary;
  final List<BudgetUsage> budgetUsages;
  final List<GoalProgress> goalProgress;
  final List<FinancialReport> reports;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get hasTransactions => transactions.isNotEmpty;
  bool get hasBudgets => budgetUsages.isNotEmpty;
  bool get hasGoals => goalProgress.isNotEmpty;
  bool get hasReports => reports.any((report) => report.hasData);

  @override
  List<Object?> get props => [
        transactions,
        transactionSummary,
        budgetUsages,
        goalProgress,
        reports,
        startDate,
        endDate,
      ];
}
