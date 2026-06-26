import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/export_params.dart';
import '../entities/export_result.dart';
import '../repository/export_repository.dart';

@injectable
class ExportDataUseCase implements UseCase<ExportResult, ExportDataParams> {
  ExportDataUseCase(this._repository);

  final ExportRepository _repository;

  @override
  Future<ExportResult> call(ExportDataParams params) {
    return _repository.exportData(params);
  }
}

@injectable
class ShareExportUseCase implements UseCase<void, ShareExportParams> {
  ShareExportUseCase(this._repository);

  final ExportRepository _repository;

  @override
  Future<void> call(ShareExportParams params) {
    return _repository.shareExport(params);
  }
}
