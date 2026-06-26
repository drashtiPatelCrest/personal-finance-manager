import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../reports/domain/entities/financial_report.dart';
import '../../domain/entities/export_labels.dart';
import '../../domain/entities/export_payload.dart';
import '../../domain/repository/export_repository.dart';

@lazySingleton
class CsvExportGenerator {
  List<int> generate({
    required ExportDataType dataType,
    required ExportPayload payload,
    required ExportLabels labels,
  }) {
    final content = switch (dataType) {
      ExportDataType.transactions => _transactionsCsv(payload, labels),
      ExportDataType.budgets => _budgetsCsv(payload, labels),
      ExportDataType.goals => _goalsCsv(payload, labels),
      ExportDataType.reports => _reportsCsv(payload, labels),
    };

    return utf8.encode(content);
  }

  String _transactionsCsv(ExportPayload payload, ExportLabels labels) {
    final buffer = StringBuffer()
      ..writeln(_row([
        labels.idLabel,
        labels.typeLabel,
        labels.amountLabel,
        labels.dateLabel,
        labels.categoryLabel,
        labels.noteLabel,
      ]));

    for (final transaction in payload.transactions) {
      buffer.writeln(
        _row([
          transaction.id,
          transaction.type.name,
          _formatAmount(transaction.amount),
          _formatDate(transaction.date),
          transaction.category.name,
          transaction.note,
        ]),
      );
    }

    return buffer.toString();
  }

  String _budgetsCsv(ExportPayload payload, ExportLabels labels) {
    final buffer = StringBuffer()
      ..writeln(_row([
        labels.idLabel,
        labels.nameLabel,
        labels.amountLabel,
        labels.dateLabel,
        '${labels.dateLabel} End',
        labels.typeLabel,
        labels.categoryLabel,
        labels.spentLabel,
        labels.remainingLabel,
        labels.usageLabel,
        labels.statusLabel,
      ]));

    for (final usage in payload.budgetUsages) {
      buffer.writeln(
        _row([
          usage.budget.id,
          usage.budget.name,
          _formatAmount(usage.budget.amount),
          _formatDate(usage.budget.startDate),
          _formatDate(usage.budget.endDate),
          usage.budget.type.name,
          usage.categoryName ?? '',
          _formatAmount(usage.spentAmount),
          _formatAmount(usage.remainingAmount),
          '${usage.usagePercentage.toStringAsFixed(1)}%',
          usage.status.name,
        ]),
      );
    }

    return buffer.toString();
  }

  String _goalsCsv(ExportPayload payload, ExportLabels labels) {
    final buffer = StringBuffer()
      ..writeln(_row([
        labels.idLabel,
        labels.nameLabel,
        labels.targetLabel,
        labels.currentLabel,
        labels.remainingLabel,
        labels.deadlineLabel,
        labels.statusLabel,
        labels.completionLabel,
      ]));

    for (final progress in payload.goalProgress) {
      final goal = progress.goal;
      buffer.writeln(
        _row([
          goal.id,
          goal.name,
          _formatAmount(goal.targetAmount),
          _formatAmount(goal.currentAmount),
          _formatAmount(goal.remainingAmount),
          _formatDate(goal.deadline),
          progress.effectiveStatus.name,
          '${progress.completionPercentage.toStringAsFixed(1)}%',
        ]),
      );
    }

    return buffer.toString();
  }

  String _reportsCsv(ExportPayload payload, ExportLabels labels) {
    final buffer = StringBuffer();

    for (final report in payload.reports) {
      buffer
        ..writeln(_reportTypeLabel(report.type, labels))
        ..writeln(
          '${labels.dateRangeLabel},${_formatDate(report.startDate)} - ${_formatDate(report.endDate)}',
        )
        ..writeln(
          '${labels.incomeLabel},${_formatAmount(report.summary.totalIncome)}',
        )
        ..writeln(
          '${labels.expenseLabel},${_formatAmount(report.summary.totalExpense)}',
        )
        ..writeln(
          '${labels.netBalanceLabel},${_formatAmount(report.summary.netBalance)}',
        )
        ..writeln(
          '${labels.transactionCountLabel},${report.summary.transactionCount}',
        );

      if (report.categoryDistribution.isNotEmpty) {
        buffer
          ..writeln()
          ..writeln(labels.chartCategoryTitle)
          ..writeln(_row([labels.categoryLabel, labels.amountLabel]));
        for (final item in report.categoryDistribution) {
          buffer.writeln(
            _row([item.categoryName, _formatAmount(item.amount)]),
          );
        }
      }

      if (report.monthlyTrend.isNotEmpty) {
        buffer
          ..writeln()
          ..writeln(labels.chartTrendTitle)
          ..writeln(
            _row([
              labels.dateLabel,
              labels.incomeLabel,
              labels.expenseLabel,
            ]),
          );
        for (final point in report.monthlyTrend) {
          buffer.writeln(
            _row([
              '${point.year}-${point.month.toString().padLeft(2, '0')}',
              _formatAmount(point.income),
              _formatAmount(point.expense),
            ]),
          );
        }
      }

      buffer.writeln();
    }

    return buffer.toString();
  }

  String _reportTypeLabel(ReportType type, ExportLabels labels) {
    return switch (type) {
      ReportType.monthly => labels.reportTypeMonthly,
      ReportType.yearly => labels.reportTypeYearly,
      ReportType.category => labels.reportTypeCategory,
      ReportType.budget => labels.reportTypeBudget,
      ReportType.goal => labels.reportTypeGoal,
    };
  }

  String _row(List<String> values) {
    return values.map(_escapeCsv).join(',');
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _formatAmount(double amount) => amount.toStringAsFixed(2);

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
