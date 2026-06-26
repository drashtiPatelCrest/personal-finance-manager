import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../reports/domain/entities/financial_report.dart';
import '../../domain/entities/export_labels.dart';
import '../../domain/entities/export_payload.dart';
import '../../domain/repository/export_repository.dart';

@lazySingleton
class PdfExportGenerator {
  Future<List<int>> generate({
    required ExportDataType dataType,
    required ExportPayload payload,
    required ExportLabels labels,
  }) async {
    final document = pw.Document();
    final generatedAt = DateTime.now();

    switch (dataType) {
      case ExportDataType.transactions:
        _buildTransactionsPdf(document, payload, labels, generatedAt);
      case ExportDataType.budgets:
        _buildBudgetsPdf(document, payload, labels, generatedAt);
      case ExportDataType.goals:
        _buildGoalsPdf(document, payload, labels, generatedAt);
      case ExportDataType.reports:
        _buildReportsPdf(document, payload, labels, generatedAt);
    }

    return document.save();
  }

  void _buildTransactionsPdf(
    pw.Document document,
    ExportPayload payload,
    ExportLabels labels,
    DateTime generatedAt,
  ) {
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _header(
            labels.transactionsTitle,
            labels,
            generatedAt,
            payload: payload,
          ),
          pw.SizedBox(height: 16),
          _summarySection(payload, labels),
          pw.SizedBox(height: 16),
          _incomeExpenseChart(payload, labels),
          pw.SizedBox(height: 16),
          _transactionsTable(payload, labels),
        ],
      ),
    );
  }

  void _buildBudgetsPdf(
    pw.Document document,
    ExportPayload payload,
    ExportLabels labels,
    DateTime generatedAt,
  ) {
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _header(labels.budgetsTitle, labels, generatedAt),
          pw.SizedBox(height: 16),
          _budgetsTable(payload, labels),
        ],
      ),
    );
  }

  void _buildGoalsPdf(
    pw.Document document,
    ExportPayload payload,
    ExportLabels labels,
    DateTime generatedAt,
  ) {
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _header(labels.goalsTitle, labels, generatedAt),
          pw.SizedBox(height: 16),
          _goalsTable(payload, labels),
        ],
      ),
    );
  }

  void _buildReportsPdf(
    pw.Document document,
    ExportPayload payload,
    ExportLabels labels,
    DateTime generatedAt,
  ) {
    for (final report in payload.reports) {
      if (!report.hasData) {
        continue;
      }

      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            _header(
              _reportTypeLabel(report.type, labels),
              labels,
              generatedAt,
              startDate: report.startDate,
              endDate: report.endDate,
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              '${labels.dateRangeLabel}: ${_formatDate(report.startDate)} - ${_formatDate(report.endDate)}',
            ),
            pw.SizedBox(height: 16),
            _reportSummary(report, labels),
            if (report.type != ReportType.budget && report.type != ReportType.goal) ...[
              pw.SizedBox(height: 16),
              _incomeExpenseChartFromReport(report, labels),
            ],
            if (report.categoryDistribution.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _categoryChart(report, labels),
            ],
            if (report.monthlyTrend.isNotEmpty &&
                report.type != ReportType.category) ...[
              pw.SizedBox(height: 16),
              _trendChart(report, labels),
            ],
            if (report.budgetUsages.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _budgetsTable(
                ExportPayload(
                  transactions: const [],
                  transactionSummary: const {},
                  budgetUsages: report.budgetUsages,
                  goalProgress: const [],
                  reports: const [],
                ),
                labels,
              ),
            ],
            if (report.goalProgress.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _goalsTable(
                ExportPayload(
                  transactions: const [],
                  transactionSummary: const {},
                  budgetUsages: const [],
                  goalProgress: report.goalProgress,
                  reports: const [],
                ),
                labels,
              ),
            ],
          ],
        ),
      );
    }
  }

  pw.Widget _header(
    String title,
    ExportLabels labels,
    DateTime generatedAt, {
    ExportPayload? payload,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final rangeStart = startDate ?? payload?.startDate;
    final rangeEnd = endDate ?? payload?.endDate;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('${labels.generatedAtLabel}: ${_formatDateTime(generatedAt)}'),
        if (rangeStart != null && rangeEnd != null)
          pw.Text(
            '${labels.dateRangeLabel}: ${_formatDate(rangeStart)} - ${_formatDate(rangeEnd)}',
          )
        else
          pw.Text('${labels.dateRangeLabel}: ${labels.allDatesLabel}'),
      ],
    );
  }

  pw.Widget _summarySection(ExportPayload payload, ExportLabels labels) {
    final income = payload.transactionSummary['income']?.toDouble() ?? 0;
    final expense = payload.transactionSummary['expense']?.toDouble() ?? 0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(labels.summaryTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('${labels.incomeLabel}: \$${_formatAmount(income)}'),
        pw.Text('${labels.expenseLabel}: \$${_formatAmount(expense)}'),
        pw.Text('${labels.netBalanceLabel}: \$${_formatAmount(income - expense)}'),
        pw.Text('${labels.transactionCountLabel}: ${payload.transactions.length}'),
      ],
    );
  }

  pw.Widget _reportSummary(FinancialReport report, ExportLabels labels) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(labels.summaryTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        if (report.summary.totalIncome > 0 || report.summary.totalExpense > 0) ...[
          pw.Text('${labels.incomeLabel}: \$${_formatAmount(report.summary.totalIncome)}'),
          pw.Text('${labels.expenseLabel}: \$${_formatAmount(report.summary.totalExpense)}'),
          pw.Text('${labels.netBalanceLabel}: \$${_formatAmount(report.summary.netBalance)}'),
        ],
        if (report.summary.totalBudgets > 0)
          pw.Text('${labels.budgetsTitle}: ${report.summary.totalBudgets}'),
        if (report.summary.activeGoalCount > 0)
          pw.Text('${labels.goalsTitle}: ${report.summary.activeGoalCount}'),
        pw.Text('${labels.transactionCountLabel}: ${report.summary.transactionCount}'),
      ],
    );
  }

  pw.Widget _incomeExpenseChart(ExportPayload payload, ExportLabels labels) {
    final income = payload.transactionSummary['income']?.toDouble() ?? 0;
    final expense = payload.transactionSummary['expense']?.toDouble() ?? 0;
    return _barChart(
      title: labels.chartIncomeExpenseTitle,
      items: [
        (labels.incomeLabel, income, PdfColors.green),
        (labels.expenseLabel, expense, PdfColors.red),
      ],
    );
  }

  pw.Widget _incomeExpenseChartFromReport(
    FinancialReport report,
    ExportLabels labels,
  ) {
    return _barChart(
      title: labels.chartIncomeExpenseTitle,
      items: [
        (labels.incomeLabel, report.summary.totalIncome, PdfColors.green),
        (labels.expenseLabel, report.summary.totalExpense, PdfColors.red),
      ],
    );
  }

  pw.Widget _categoryChart(FinancialReport report, ExportLabels labels) {
    final items = report.categoryDistribution
        .take(5)
        .map(
          (item) => (
            item.categoryName,
            item.amount,
            PdfColors.blue,
          ),
        )
        .toList();

    return _barChart(title: labels.chartCategoryTitle, items: items);
  }

  pw.Widget _trendChart(FinancialReport report, ExportLabels labels) {
    final maxValue = report.monthlyTrend
        .expand((point) => [point.income, point.expense])
        .fold<double>(0, (max, value) => value > max ? value : max);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(labels.chartTrendTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        ...report.monthlyTrend.map(
          (point) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${point.year}-${point.month.toString().padLeft(2, '0')}'),
                _barRow(labels.incomeLabel, point.income, maxValue, PdfColors.green),
                _barRow(labels.expenseLabel, point.expense, maxValue, PdfColors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _barChart({
    required String title,
    required List<(String, double, PdfColor)> items,
  }) {
    final maxValue = items.fold<double>(
      0,
      (max, item) => item.$2 > max ? item.$2 : max,
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        ...items.map(
          (item) => _barRow(item.$1, item.$2, maxValue, item.$3),
        ),
      ],
    );
  }

  pw.Widget _barRow(
    String label,
    double value,
    double maxValue,
    PdfColor color,
  ) {
    final width = maxValue <= 0 ? 0.0 : (value / maxValue) * 200;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          ),
          pw.Container(
            width: width,
            height: 12,
            color: color,
          ),
          pw.SizedBox(width: 8),
          pw.Text('\$${_formatAmount(value)}', style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _transactionsTable(ExportPayload payload, ExportLabels labels) {
    return _table(
      headers: [
        labels.dateLabel,
        labels.typeLabel,
        labels.categoryLabel,
        labels.amountLabel,
        labels.noteLabel,
      ],
      rows: payload.transactions
          .map(
            (transaction) => [
              _formatDate(transaction.date),
              transaction.type.name,
              transaction.category.name,
              '\$${_formatAmount(transaction.amount)}',
              transaction.note,
            ],
          )
          .toList(),
    );
  }

  pw.Widget _budgetsTable(ExportPayload payload, ExportLabels labels) {
    return _table(
      headers: [
        labels.nameLabel,
        labels.amountLabel,
        labels.spentLabel,
        labels.remainingLabel,
        labels.usageLabel,
        labels.statusLabel,
      ],
      rows: payload.budgetUsages
          .map(
            (usage) => [
              usage.budget.name,
              '\$${_formatAmount(usage.budget.amount)}',
              '\$${_formatAmount(usage.spentAmount)}',
              '\$${_formatAmount(usage.remainingAmount)}',
              '${usage.usagePercentage.toStringAsFixed(1)}%',
              usage.status.name,
            ],
          )
          .toList(),
    );
  }

  pw.Widget _goalsTable(ExportPayload payload, ExportLabels labels) {
    return _table(
      headers: [
        labels.nameLabel,
        labels.targetLabel,
        labels.currentLabel,
        labels.completionLabel,
        labels.deadlineLabel,
        labels.statusLabel,
      ],
      rows: payload.goalProgress
          .map(
            (progress) => [
              progress.goal.name,
              '\$${_formatAmount(progress.goal.targetAmount)}',
              '\$${_formatAmount(progress.goal.currentAmount)}',
              '${progress.completionPercentage.toStringAsFixed(1)}%',
              _formatDate(progress.goal.deadline),
              progress.effectiveStatus.name,
            ],
          )
          .toList(),
    );
  }

  pw.Widget _table({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 24,
    );
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

  String _formatAmount(double amount) => amount.toStringAsFixed(2);

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _formatDateTime(DateTime date) =>
      '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
