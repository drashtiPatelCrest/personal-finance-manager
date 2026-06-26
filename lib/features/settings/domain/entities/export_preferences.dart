import 'package:equatable/equatable.dart';

import '../../../reports/domain/entities/financial_report.dart';

class ExportPreferences extends Equatable {
  const ExportPreferences({
    this.useDateFilter = false,
    this.dateRangePreset = ReportDateRangePreset.thisMonth,
  });

  final bool useDateFilter;
  final ReportDateRangePreset dateRangePreset;

  ExportPreferences copyWith({
    bool? useDateFilter,
    ReportDateRangePreset? dateRangePreset,
  }) {
    return ExportPreferences(
      useDateFilter: useDateFilter ?? this.useDateFilter,
      dateRangePreset: dateRangePreset ?? this.dateRangePreset,
    );
  }

  @override
  List<Object?> get props => [useDateFilter, dateRangePreset];
}
