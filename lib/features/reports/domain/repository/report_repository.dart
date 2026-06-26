import '../entities/financial_report.dart';

abstract class ReportRepository {
  Future<FinancialReport> generateReport(ReportFilter filter);
}
