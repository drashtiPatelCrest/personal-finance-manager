part of 'budget_detail_bloc.dart';

final class BudgetDetailState extends BaseState {
  const BudgetDetailState({
    super.status = BaseStatus.initial,
    super.message,
    this.usage,
    this.errorCode,
    this.isDeleting = false,
    this.deleted = false,
  });

  final BudgetUsage? usage;
  final BudgetErrorCode? errorCode;
  final bool isDeleting;
  final bool deleted;

  BudgetDetailState copyWith({
    BaseStatus? status,
    String? message,
    BudgetUsage? usage,
    BudgetErrorCode? errorCode,
    bool? isDeleting,
    bool? deleted,
    bool clearError = false,
  }) {
    return BudgetDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      usage: usage ?? this.usage,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      isDeleting: isDeleting ?? this.isDeleting,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        usage,
        errorCode,
        isDeleting,
        deleted,
      ];
}
