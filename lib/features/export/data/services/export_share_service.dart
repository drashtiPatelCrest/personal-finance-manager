import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/export_params.dart';
import '../../domain/repository/export_repository.dart';

@lazySingleton
class ExportShareService {
  Future<void> shareExport(ShareExportParams params) async {
    final mimeType = switch (params.format) {
      ExportFormat.pdf => 'application/pdf',
      ExportFormat.csv => 'text/csv',
    };

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(params.filePath, mimeType: mimeType)],
        subject: _shareSubject(params.dataType),
      ),
    );
  }

  String _shareSubject(ExportDataType dataType) {
    return switch (dataType) {
      ExportDataType.transactions => 'Transactions Export',
      ExportDataType.budgets => 'Budgets Export',
      ExportDataType.goals => 'Goals Export',
      ExportDataType.reports => 'Reports Export',
    };
  }
}
