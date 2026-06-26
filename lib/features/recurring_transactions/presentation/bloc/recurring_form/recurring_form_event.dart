part of 'recurring_form_bloc.dart';

sealed class RecurringFormEvent extends Equatable {
  const RecurringFormEvent();

  @override
  List<Object?> get props => [];
}

final class RecurringFormLoadRequested extends RecurringFormEvent {
  const RecurringFormLoadRequested({
    this.recurringId,
    this.initialType,
  });

  final String? recurringId;
  final TransactionType? initialType;

  @override
  List<Object?> get props => [recurringId, initialType];
}

final class RecurringFormSubmitted extends RecurringFormEvent {
  const RecurringFormSubmitted({
    required this.amount,
    required this.note,
  });

  final double amount;
  final String note;

  @override
  List<Object?> get props => [amount, note];
}

final class RecurringFormTypeChanged extends RecurringFormEvent {
  const RecurringFormTypeChanged(this.type);

  final TransactionType type;

  @override
  List<Object?> get props => [type];
}

final class RecurringFormCategoryChanged extends RecurringFormEvent {
  const RecurringFormCategoryChanged(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class RecurringFormFrequencyChanged extends RecurringFormEvent {
  const RecurringFormFrequencyChanged(this.frequency);

  final RecurrenceFrequency frequency;

  @override
  List<Object?> get props => [frequency];
}

final class RecurringFormNextExecutionChanged extends RecurringFormEvent {
  const RecurringFormNextExecutionChanged(this.nextExecutionDate);

  final DateTime nextExecutionDate;

  @override
  List<Object?> get props => [nextExecutionDate];
}
