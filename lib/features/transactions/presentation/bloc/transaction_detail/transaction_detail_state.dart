part of 'transaction_detail_bloc.dart';

final class TransactionDetailState extends BaseState {
  const TransactionDetailState({
    super.status = BaseStatus.initial,
    super.message,
    this.transaction,
    this.errorCode,
    this.isDeleting = false,
    this.deleted = false,
  });

  final Transaction? transaction;
  final TransactionErrorCode? errorCode;
  final bool isDeleting;
  final bool deleted;

  TransactionDetailState copyWith({
    BaseStatus? status,
    String? message,
    Transaction? transaction,
    TransactionErrorCode? errorCode,
    bool? isDeleting,
    bool? deleted,
    bool clearError = false,
  }) {
    return TransactionDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      transaction: transaction ?? this.transaction,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      isDeleting: isDeleting ?? this.isDeleting,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        transaction,
        errorCode,
        isDeleting,
        deleted,
      ];
}
