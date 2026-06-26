part of 'transaction_form_bloc.dart';

sealed class TransactionFormEvent extends Equatable {
  const TransactionFormEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionFormLoadRequested extends TransactionFormEvent {
  const TransactionFormLoadRequested({
    this.transactionId,
    this.initialType,
  });

  final String? transactionId;
  final TransactionType? initialType;

  @override
  List<Object?> get props => [transactionId, initialType];
}

final class TransactionFormSubmitted extends TransactionFormEvent {
  const TransactionFormSubmitted({
    required this.amount,
    required this.note,
  });

  final double amount;
  final String note;

  @override
  List<Object?> get props => [amount, note];
}

final class TransactionFormTypeChanged extends TransactionFormEvent {
  const TransactionFormTypeChanged(this.type);

  final TransactionType type;

  @override
  List<Object?> get props => [type];
}

final class TransactionFormCategoryChanged extends TransactionFormEvent {
  const TransactionFormCategoryChanged(this.categoryId);

  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class TransactionFormDateChanged extends TransactionFormEvent {
  const TransactionFormDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}
