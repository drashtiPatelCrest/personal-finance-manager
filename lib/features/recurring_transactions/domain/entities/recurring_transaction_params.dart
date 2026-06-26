import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction.dart';
import 'recurring_transaction.dart';

class CreateRecurringTransactionParams extends Equatable {
  const CreateRecurringTransactionParams({
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.frequency,
    required this.nextExecutionDate,
    required this.note,
  });

  final TransactionType type;
  final double amount;
  final String categoryId;
  final RecurrenceFrequency frequency;
  final DateTime nextExecutionDate;
  final String note;

  @override
  List<Object?> get props => [
        type,
        amount,
        categoryId,
        frequency,
        nextExecutionDate,
        note,
      ];
}

class UpdateRecurringTransactionParams extends Equatable {
  const UpdateRecurringTransactionParams({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.frequency,
    required this.nextExecutionDate,
    required this.note,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final String categoryId;
  final RecurrenceFrequency frequency;
  final DateTime nextExecutionDate;
  final String note;

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        categoryId,
        frequency,
        nextExecutionDate,
        note,
      ];
}

class DeleteRecurringTransactionParams extends Equatable {
  const DeleteRecurringTransactionParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class RecurringTransactionIdParams extends Equatable {
  const RecurringTransactionIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class WatchRecurringTransactionsParams extends Equatable {
  const WatchRecurringTransactionsParams({
    this.isPaused,
    this.query,
  });

  final bool? isPaused;
  final String? query;

  @override
  List<Object?> get props => [isPaused, query];
}

class GetRecurringTransactionsParams extends Equatable {
  const GetRecurringTransactionsParams({
    this.isPaused,
    this.query,
  });

  final bool? isPaused;
  final String? query;

  @override
  List<Object?> get props => [isPaused, query];
}

class GetRecurringTransactionByIdParams extends Equatable {
  const GetRecurringTransactionByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
