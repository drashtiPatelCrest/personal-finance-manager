part of 'export_bloc.dart';

final class ExportState extends BaseState {
  const ExportState({
    super.status = BaseStatus.initial,
    super.message,
    this.dateRangePreset = ReportDateRangePreset.thisMonth,
    this.useDateFilter = false,
    this.lastResult,
    this.exportingDataType,
    this.exportingFormat,
    this.errorCode,
    this.errorNonce = 0,
    this.successNonce = 0,
  });

  final ReportDateRangePreset dateRangePreset;
  final bool useDateFilter;
  final ExportResult? lastResult;
  final ExportDataType? exportingDataType;
  final ExportFormat? exportingFormat;
  final ExportErrorCode? errorCode;
  final int errorNonce;
  final int successNonce;

  factory ExportState.initial() => const ExportState();

  bool isExporting(ExportDataType dataType, ExportFormat format) {
    return isLoading &&
        exportingDataType == dataType &&
        exportingFormat == format;
  }

  ExportState copyWith({
    BaseStatus? status,
    String? message,
    ReportDateRangePreset? dateRangePreset,
    bool? useDateFilter,
    ExportResult? lastResult,
    ExportDataType? exportingDataType,
    ExportFormat? exportingFormat,
    ExportErrorCode? errorCode,
    int? errorNonce,
    int? successNonce,
    bool clearError = false,
    bool clearExporting = false,
  }) {
    return ExportState(
      status: status ?? this.status,
      message: message ?? this.message,
      dateRangePreset: dateRangePreset ?? this.dateRangePreset,
      useDateFilter: useDateFilter ?? this.useDateFilter,
      lastResult: lastResult ?? this.lastResult,
      exportingDataType:
          clearExporting ? null : exportingDataType ?? this.exportingDataType,
      exportingFormat:
          clearExporting ? null : exportingFormat ?? this.exportingFormat,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
      successNonce: successNonce ?? this.successNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        dateRangePreset,
        useDateFilter,
        lastResult,
        exportingDataType,
        exportingFormat,
        errorCode,
        errorNonce,
        successNonce,
      ];
}
