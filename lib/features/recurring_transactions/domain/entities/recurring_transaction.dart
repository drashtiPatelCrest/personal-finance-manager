import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/category.dart';
import '../../../transactions/domain/entities/transaction.dart';

enum RecurrenceFrequency { daily, weekly, monthly, yearly }

class RecurringTransaction extends Equatable {
  const RecurringTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.frequency,
    required this.nextExecutionDate,
    required this.isPaused,
    required this.note,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final Category category;
  final RecurrenceFrequency frequency;
  final DateTime nextExecutionDate;
  final bool isPaused;
  final String note;

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        category,
        frequency,
        nextExecutionDate,
        isPaused,
        note,
      ];
}
