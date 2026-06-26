import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../domain/entities/financial_report.dart';
import '../../domain/entities/report_error_code.dart';
import 'report_localization.dart';

extension ReportErrorContext on BuildContext {
  String reportErrorMessage(ReportErrorCode code) => code.message(l10n);
}

extension ReportTypeContext on BuildContext {
  String reportTypeLabel(ReportType type) => type.label(l10n);

  String reportTypeDescription(ReportType type) => type.description(l10n);
}

extension ReportDateRangeContext on BuildContext {
  String reportDateRangeLabel(ReportDateRangePreset preset) => preset.label(l10n);
}

ReportType? parseReportType(String? value) {
  if (value == null) {
    return null;
  }

  for (final type in ReportType.values) {
    if (type.name == value) {
      return type;
    }
  }
  return null;
}
