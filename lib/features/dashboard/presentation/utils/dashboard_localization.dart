import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/dashboard_error_code.dart';
import '../../domain/entities/dashboard_snapshot.dart';

extension DashboardErrorLocalization on DashboardErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      DashboardErrorCode.unknown => l10n.dashboardErrorUnknown,
    };
  }
}

extension DashboardErrorContext on BuildContext {
  String dashboardErrorMessage(DashboardErrorCode code) => code.message(l10n);
}

extension DashboardDateRangeLocalization on DashboardDateRangePreset {
  String label(AppLocalizations l10n) {
    return switch (this) {
      DashboardDateRangePreset.thisMonth => l10n.dashboardRangeThisMonth,
      DashboardDateRangePreset.lastMonth => l10n.dashboardRangeLastMonth,
      DashboardDateRangePreset.lastThreeMonths => l10n.dashboardRangeLastThreeMonths,
      DashboardDateRangePreset.lastSixMonths => l10n.dashboardRangeLastSixMonths,
      DashboardDateRangePreset.thisYear => l10n.dashboardRangeThisYear,
    };
  }
}

extension DashboardDateRangeContext on BuildContext {
  String dashboardDateRangeLabel(DashboardDateRangePreset preset) =>
      preset.label(l10n);
}
