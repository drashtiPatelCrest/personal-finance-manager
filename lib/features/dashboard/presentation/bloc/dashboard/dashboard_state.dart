part of 'dashboard_bloc.dart';

final class DashboardState extends BaseState {
  const DashboardState({
    super.status = BaseStatus.initial,
    super.message,
    this.snapshot,
    this.dateRangePreset = DashboardDateRangePreset.thisMonth,
    this.errorCode,
    this.errorNonce = 0,
  });

  final DashboardSnapshot? snapshot;
  final DashboardDateRangePreset dateRangePreset;
  final DashboardErrorCode? errorCode;
  final int errorNonce;

  factory DashboardState.initial() => const DashboardState();

  DashboardState copyWith({
    BaseStatus? status,
    String? message,
    DashboardSnapshot? snapshot,
    DashboardDateRangePreset? dateRangePreset,
    DashboardErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
    bool clearSnapshot = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      message: message ?? this.message,
      snapshot: clearSnapshot ? null : snapshot ?? this.snapshot,
      dateRangePreset: dateRangePreset ?? this.dateRangePreset,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        snapshot,
        dateRangePreset,
        errorCode,
        errorNonce,
      ];
}
