import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/category.dart';

enum TransactionType { income, expense }

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final Category category;
  final DateTime date;
  final String note;

  @override
  List<Object?> get props => [id, type, amount, category, date, note];
}

class TransactionFilter extends Equatable {
  const TransactionFilter({
    this.type,
    this.categoryId,
    this.startDate,
    this.endDate,
    this.query,
  });

  final TransactionType? type;
  final String? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? query;

  @override
  List<Object?> get props => [type, categoryId, startDate, endDate, query];
}
