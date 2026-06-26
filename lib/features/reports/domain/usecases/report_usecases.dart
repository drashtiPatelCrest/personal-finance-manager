import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/financial_report.dart';
import '../../domain/repository/report_repository.dart';

@injectable
class GenerateReportUseCase implements UseCase<FinancialReport, ReportFilter> {
  GenerateReportUseCase(this._repository);

  final ReportRepository _repository;

  @override
  Future<FinancialReport> call(ReportFilter filter) {
    return _repository.generateReport(filter);
  }
}
