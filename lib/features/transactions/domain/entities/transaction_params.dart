import 'package:equatable/equatable.dart';

import 'transaction.dart';

class CreateTransactionParams extends Equatable {
  const CreateTransactionParams({
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note = '',
  });

  final TransactionType type;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String note;

  @override
  List<Object?> get props => [type, amount, categoryId, date, note];
}

class UpdateTransactionParams extends Equatable {
  const UpdateTransactionParams({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note = '',
  });

  final String id;
  final TransactionType type;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String note;

  @override
  List<Object?> get props => [id, type, amount, categoryId, date, note];
}

class DeleteTransactionParams extends Equatable {
  const DeleteTransactionParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class WatchTransactionsParams extends Equatable {
  const WatchTransactionsParams({this.filter});

  final TransactionFilter? filter;

  @override
  List<Object?> get props => [filter];
}

class GetTransactionsParams extends Equatable {
  const GetTransactionsParams({this.filter});

  final TransactionFilter? filter;

  @override
  List<Object?> get props => [filter];
}

class GetTransactionByIdParams extends Equatable {
  const GetTransactionByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class GetTransactionSummaryParams extends Equatable {
  const GetTransactionSummaryParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}
