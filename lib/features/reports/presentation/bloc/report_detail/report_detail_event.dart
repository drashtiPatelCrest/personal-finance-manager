part of 'report_detail_bloc.dart';

sealed class ReportDetailEvent extends Equatable {
  const ReportDetailEvent();

  @override
  List<Object?> get props => [];
}

final class ReportDetailStarted extends ReportDetailEvent {
  const ReportDetailStarted(this.reportType);

  final ReportType reportType;

  @override
  List<Object?> get props => [reportType];
}

final class ReportDetailDateRangeChanged extends ReportDetailEvent {
  const ReportDetailDateRangeChanged(this.preset);

  final ReportDateRangePreset preset;

  @override
  List<Object?> get props => [preset];
}

final class ReportDetailCategoryChanged extends ReportDetailEvent {
  const ReportDetailCategoryChanged(this.categoryId);

  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class ReportDetailRefreshRequested extends ReportDetailEvent {
  const ReportDetailRefreshRequested();
}
