part of 'recurring_detail_bloc.dart';

final class RecurringDetailState extends BaseState {
  const RecurringDetailState({
    super.status = BaseStatus.initial,
    super.message,
    this.recurring,
    this.errorCode,
    this.errorNonce = 0,
    this.isDeleting = false,
    this.isUpdatingStatus = false,
    this.deleted = false,
    this.statusChanged = false,
  });

  final RecurringTransaction? recurring;
  final RecurringTransactionErrorCode? errorCode;
  final int errorNonce;
  final bool isDeleting;
  final bool isUpdatingStatus;
  final bool deleted;
  final bool statusChanged;

  RecurringDetailState copyWith({
    BaseStatus? status,
    String? message,
    RecurringTransaction? recurring,
    RecurringTransactionErrorCode? errorCode,
    int? errorNonce,
    bool? isDeleting,
    bool? isUpdatingStatus,
    bool? deleted,
    bool? statusChanged,
    bool clearError = false,
  }) {
    return RecurringDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      recurring: recurring ?? this.recurring,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
      isDeleting: isDeleting ?? this.isDeleting,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
      deleted: deleted ?? this.deleted,
      statusChanged: statusChanged ?? this.statusChanged,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        recurring,
        errorCode,
        errorNonce,
        isDeleting,
        isUpdatingStatus,
        deleted,
        statusChanged,
      ];
}
