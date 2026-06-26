import 'package:equatable/equatable.dart';

import '../repository/export_repository.dart';

class ExportResult extends Equatable {
  const ExportResult({
    required this.filePath,
    required this.fileName,
    required this.format,
    required this.dataType,
  });

  final String filePath;
  final String fileName;
  final ExportFormat format;
  final ExportDataType dataType;

  @override
  List<Object?> get props => [filePath, fileName, format, dataType];
}
