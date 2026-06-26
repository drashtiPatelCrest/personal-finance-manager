import 'package:equatable/equatable.dart';

import '../repository/export_repository.dart';
import 'export_labels.dart';

class ExportDataParams extends Equatable {
  const ExportDataParams({
    required this.dataType,
    required this.format,
    required this.labels,
    this.startDate,
    this.endDate,
  });

  final ExportDataType dataType;
  final ExportFormat format;
  final ExportLabels labels;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [
        dataType,
        format,
        labels,
        startDate,
        endDate,
      ];
}

class ShareExportParams extends Equatable {
  const ShareExportParams({
    required this.filePath,
    required this.format,
    required this.dataType,
  });

  final String filePath;
  final ExportFormat format;
  final ExportDataType dataType;

  @override
  List<Object?> get props => [filePath, format, dataType];
}
