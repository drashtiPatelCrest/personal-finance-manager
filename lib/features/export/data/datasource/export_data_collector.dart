import 'package:injectable/injectable.dart';

import '../../../budgets/data/datasource/budget_local_datasource.dart';
import '../../../goals/data/datasource/goal_local_datasource.dart';
import '../../../reports/data/datasource/report_local_datasource.dart';
import '../../../reports/domain/entities/financial_report.dart';
import '../../../transactions/data/datasource/transaction_local_datasource.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/export_error_code.dart';
import '../../domain/entities/export_payload.dart';
import '../../domain/repository/export_repository.dart';

@lazySingleton
class ExportDataCollector {
  ExportDataCollector(
    this._transactionDataSource,
    this._budgetDataSource,
    this._goalDataSource,
    this._reportDataSource,
  );

  final TransactionLocalDataSource _transactionDataSource;
  final BudgetLocalDataSource _budgetDataSource;
  final GoalLocalDataSource _goalDataSource;
  final ReportLocalDataSource _reportDataSource;

  Future<ExportPayload> collect({
    required ExportDataType dataType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return switch (dataType) {
        ExportDataType.transactions => _collectTransactions(
            startDate: startDate,
            endDate: endDate,
          ),
        ExportDataType.budgets => _collectBudgets(),
        ExportDataType.goals => _collectGoals(),
        ExportDataType.reports => _collectReports(
            startDate: startDate,
            endDate: endDate,
          ),
      };
    } catch (_) {
      throw const ExportException(ExportErrorCode.unknown);
    }
  }

  Future<ExportPayload> _collectTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final filter = (startDate != null && endDate != null)
        ? TransactionFilter(startDate: startDate, endDate: endDate)
        : null;

    final transactions = await _transactionDataSource.getTransactions(
      filter: filter,
    );

    Map<String, num> summary = const {};
    if (startDate != null && endDate != null) {
      summary = await _transactionDataSource.getSummary(
        startDate: startDate,
        endDate: endDate,
      );
    } else if (transactions.isNotEmpty) {
      final dates = transactions.map((transaction) => transaction.date).toList()
        ..sort();
      summary = await _transactionDataSource.getSummary(
        startDate: dates.first,
        endDate: dates.last,
      );
    }

    return ExportPayload(
      transactions: transactions,
      transactionSummary: summary,
      budgetUsages: const [],
      goalProgress: const [],
      reports: const [],
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<ExportPayload> _collectBudgets() async {
    final budgets = await _budgetDataSource.getBudgets();
    final budgetUsages = await Future.wait(
      budgets.map((budget) => _budgetDataSource.getBudgetUsage(budget.id)),
    );

    return ExportPayload(
      transactions: const [],
      transactionSummary: const {},
      budgetUsages: budgetUsages,
      goalProgress: const [],
      reports: const [],
    );
  }

  Future<ExportPayload> _collectGoals() async {
    final goals = await _goalDataSource.getGoals();
    final goalProgress = await Future.wait(
      goals.map((goal) => _goalDataSource.getGoalProgress(goal.id)),
    );

    return ExportPayload(
      transactions: const [],
      transactionSummary: const {},
      budgetUsages: const [],
      goalProgress: goalProgress,
      reports: const [],
    );
  }

  Future<ExportPayload> _collectReports({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final reports = <FinancialReport>[];
    for (final type in ReportType.values) {
      final preset = type.defaultDateRangePreset();
      final range = type.supportsDateRangeFilter() &&
              startDate != null &&
              endDate != null
          ? (startDate: startDate, endDate: endDate)
          : preset.resolve();

      final report = await _reportDataSource.generateReport(
        ReportFilter(
          type: type,
          startDate: range.startDate,
          endDate: range.endDate,
          dateRangePreset: preset,
        ),
      );
      reports.add(report);
    }

    return ExportPayload(
      transactions: const [],
      transactionSummary: const {},
      budgetUsages: const [],
      goalProgress: const [],
      reports: reports,
      startDate: startDate,
      endDate: endDate,
    );
  }

  bool hasDataForType(ExportPayload payload, ExportDataType dataType) {
    return switch (dataType) {
      ExportDataType.transactions => payload.hasTransactions,
      ExportDataType.budgets => payload.hasBudgets,
      ExportDataType.goals => payload.hasGoals,
      ExportDataType.reports => payload.hasReports,
    };
  }
}
