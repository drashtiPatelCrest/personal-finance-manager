part of 'transaction_list_bloc.dart';

sealed class TransactionListEvent extends Equatable {
  const TransactionListEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionListStarted extends TransactionListEvent {
  const TransactionListStarted();
}

final class TransactionListSearchChanged extends TransactionListEvent {
  const TransactionListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class TransactionListTypeFilterChanged extends TransactionListEvent {
  const TransactionListTypeFilterChanged(this.type);

  final TransactionType? type;

  @override
  List<Object?> get props => [type];
}

final class TransactionListCategoryFilterChanged extends TransactionListEvent {
  const TransactionListCategoryFilterChanged(this.categoryId);

  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class TransactionListDateRangeChanged extends TransactionListEvent {
  const TransactionListDateRangeChanged({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

final class TransactionListDateRangeCleared extends TransactionListEvent {
  const TransactionListDateRangeCleared();
}

final class TransactionListDeleteRequested extends TransactionListEvent {
  const TransactionListDeleteRequested(this.transactionId);

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

final class TransactionListUpdated extends TransactionListEvent {
  const TransactionListUpdated(this.transactions);

  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

final class TransactionListFailed extends TransactionListEvent {
  const TransactionListFailed(this.errorCode);

  final TransactionErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
