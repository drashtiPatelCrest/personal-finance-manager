part of 'report_detail_bloc.dart';

final class ReportDetailState extends BaseState {
  const ReportDetailState({
    super.status = BaseStatus.initial,
    super.message,
    this.reportType,
    this.report,
    this.dateRangePreset = ReportDateRangePreset.thisMonth,
    this.selectedCategoryId,
    this.categories = const [],
    this.errorCode,
    this.errorNonce = 0,
  });

  final ReportType? reportType;
  final FinancialReport? report;
  final ReportDateRangePreset dateRangePreset;
  final String? selectedCategoryId;
  final List<Category> categories;
  final ReportErrorCode? errorCode;
  final int errorNonce;

  factory ReportDetailState.initial() => const ReportDetailState();

  List<Category> get expenseCategories =>
      categories.where((category) => category.type == CategoryType.expense).toList();

  ReportDetailState copyWith({
    BaseStatus? status,
    String? message,
    ReportType? reportType,
    FinancialReport? report,
    ReportDateRangePreset? dateRangePreset,
    String? selectedCategoryId,
    List<Category>? categories,
    ReportErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
    bool clearReport = false,
    bool clearSelectedCategoryId = false,
  }) {
    return ReportDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      reportType: reportType ?? this.reportType,
      report: clearReport ? null : report ?? this.report,
      dateRangePreset: dateRangePreset ?? this.dateRangePreset,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      categories: categories ?? this.categories,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        reportType,
        report,
        dateRangePreset,
        selectedCategoryId,
        categories,
        errorCode,
        errorNonce,
      ];
}
