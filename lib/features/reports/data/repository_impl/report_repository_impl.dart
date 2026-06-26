import 'package:injectable/injectable.dart';

import '../../domain/entities/financial_report.dart';
import '../../domain/repository/report_repository.dart';
import '../datasource/report_local_datasource.dart';

@LazySingleton(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._dataSource);

  final ReportLocalDataSource _dataSource;

  @override
  Future<FinancialReport> generateReport(ReportFilter filter) {
    return _dataSource.generateReport(filter);
  }
}
