part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

final class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

final class DashboardDateRangeChanged extends DashboardEvent {
  const DashboardDateRangeChanged(this.preset);

  final DashboardDateRangePreset preset;

  @override
  List<Object?> get props => [preset];
}

final class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

final class DashboardDataUpdated extends DashboardEvent {
  const DashboardDataUpdated();
}

final class DashboardFailed extends DashboardEvent {
  const DashboardFailed(this.errorCode);

  final DashboardErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
