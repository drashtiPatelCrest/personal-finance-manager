import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/financial_report.dart';
import '../../domain/entities/report_error_code.dart';

extension ReportErrorLocalization on ReportErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      ReportErrorCode.unknown => l10n.reportErrorUnknown,
    };
  }
}

extension ReportTypeLocalization on ReportType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      ReportType.monthly => l10n.reportTypeMonthly,
      ReportType.yearly => l10n.reportTypeYearly,
      ReportType.category => l10n.reportTypeCategory,
      ReportType.budget => l10n.reportTypeBudget,
      ReportType.goal => l10n.reportTypeGoal,
    };
  }

  String description(AppLocalizations l10n) {
    return switch (this) {
      ReportType.monthly => l10n.reportTypeMonthlyDescription,
      ReportType.yearly => l10n.reportTypeYearlyDescription,
      ReportType.category => l10n.reportTypeCategoryDescription,
      ReportType.budget => l10n.reportTypeBudgetDescription,
      ReportType.goal => l10n.reportTypeGoalDescription,
    };
  }
}

extension ReportDateRangeLocalization on ReportDateRangePreset {
  String label(AppLocalizations l10n) {
    return switch (this) {
      ReportDateRangePreset.thisMonth => l10n.reportRangeThisMonth,
      ReportDateRangePreset.lastMonth => l10n.reportRangeLastMonth,
      ReportDateRangePreset.lastThreeMonths => l10n.reportRangeLastThreeMonths,
      ReportDateRangePreset.lastSixMonths => l10n.reportRangeLastSixMonths,
      ReportDateRangePreset.thisYear => l10n.reportRangeThisYear,
    };
  }
}
