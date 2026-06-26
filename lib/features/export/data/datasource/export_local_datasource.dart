import 'package:injectable/injectable.dart';

import '../../domain/entities/export_error_code.dart';
import '../../domain/entities/export_params.dart';
import '../../domain/entities/export_result.dart';
import '../../domain/repository/export_repository.dart';
import '../services/export_file_storage.dart';
import 'csv_export_generator.dart';
import 'export_data_collector.dart';
import 'pdf_export_generator.dart';

@lazySingleton
class ExportLocalDataSource {
  ExportLocalDataSource(
    this._dataCollector,
    this._fileStorage,
    this._csvGenerator,
    this._pdfGenerator,
  );

  final ExportDataCollector _dataCollector;
  final ExportFileStorage _fileStorage;
  final CsvExportGenerator _csvGenerator;
  final PdfExportGenerator _pdfGenerator;

  Future<ExportResult> exportData(ExportDataParams params) async {
    try {
      final payload = await _dataCollector.collect(
        dataType: params.dataType,
        startDate: params.startDate,
        endDate: params.endDate,
      );

      if (!_dataCollector.hasDataForType(payload, params.dataType)) {
        throw const ExportException(ExportErrorCode.noData);
      }

      final bytes = switch (params.format) {
        ExportFormat.csv => _csvGenerator.generate(
            dataType: params.dataType,
            payload: payload,
            labels: params.labels,
          ),
        ExportFormat.pdf => await _pdfGenerator.generate(
            dataType: params.dataType,
            payload: payload,
            labels: params.labels,
          ),
      };

      final extension = params.format.name;
      final fileName = _buildFileName(params.dataType, extension);
      final filePath = await _fileStorage.writeFile(
        fileName: fileName,
        bytes: bytes,
      );

      return ExportResult(
        filePath: filePath,
        fileName: fileName,
        format: params.format,
        dataType: params.dataType,
      );
    } on ExportException {
      rethrow;
    } catch (_) {
      throw const ExportException(ExportErrorCode.fileWriteFailed);
    }
  }

  String _buildFileName(ExportDataType dataType, String extension) {
    final timestamp = DateTime.now();
    final stamp =
        '${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}${timestamp.millisecond.toString().padLeft(3, '0')}';
    return '${dataType.name}_$stamp.$extension';
  }
}
