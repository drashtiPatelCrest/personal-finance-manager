import 'package:injectable/injectable.dart';

import '../../domain/entities/export_params.dart';
import '../../domain/entities/export_result.dart';
import '../../domain/repository/export_repository.dart';
import '../datasource/export_local_datasource.dart';
import '../services/export_share_service.dart';

@LazySingleton(as: ExportRepository)
class ExportRepositoryImpl implements ExportRepository {
  ExportRepositoryImpl(
    this._dataSource,
    this._shareService,
  );

  final ExportLocalDataSource _dataSource;
  final ExportShareService _shareService;

  @override
  Future<ExportResult> exportData(ExportDataParams params) {
    return _dataSource.exportData(params);
  }

  @override
  Future<void> shareExport(ShareExportParams params) {
    return _shareService.shareExport(params);
  }
}
