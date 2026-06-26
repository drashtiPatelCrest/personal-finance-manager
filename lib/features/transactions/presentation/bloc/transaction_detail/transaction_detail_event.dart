part of 'transaction_detail_bloc.dart';

sealed class TransactionDetailEvent extends Equatable {
  const TransactionDetailEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionDetailLoadRequested extends TransactionDetailEvent {
  const TransactionDetailLoadRequested(this.transactionId);

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

final class TransactionDetailDeleteRequested extends TransactionDetailEvent {
  const TransactionDetailDeleteRequested(this.transactionId);

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}
