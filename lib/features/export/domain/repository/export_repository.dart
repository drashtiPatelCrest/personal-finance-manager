import '../entities/export_params.dart';
import '../entities/export_result.dart';

enum ExportFormat { pdf, csv }

enum ExportDataType { transactions, budgets, goals, reports }

abstract class ExportRepository {
  Future<ExportResult> exportData(ExportDataParams params);

  Future<void> shareExport(ShareExportParams params);
}
