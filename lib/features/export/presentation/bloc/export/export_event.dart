part of 'export_bloc.dart';

sealed class ExportEvent extends Equatable {
  const ExportEvent();

  @override
  List<Object?> get props => [];
}

final class ExportDateRangeChanged extends ExportEvent {
  const ExportDateRangeChanged(this.preset);

  final ReportDateRangePreset preset;

  @override
  List<Object?> get props => [preset];
}

final class ExportDateFilterToggled extends ExportEvent {
  const ExportDateFilterToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class ExportStarted extends ExportEvent {
  const ExportStarted();
}

final class ExportRequested extends ExportEvent {
  const ExportRequested({
    required this.dataType,
    required this.format,
    required this.labels,
  });

  final ExportDataType dataType;
  final ExportFormat format;
  final ExportLabels labels;

  @override
  List<Object?> get props => [dataType, format, labels];
}

final class ExportShareRequested extends ExportEvent {
  const ExportShareRequested({
    required this.filePath,
    required this.format,
    required this.dataType,
  });

  final String filePath;
  final ExportFormat format;
  final ExportDataType dataType;

  @override
  List<Object?> get props => [filePath, format, dataType];
}
