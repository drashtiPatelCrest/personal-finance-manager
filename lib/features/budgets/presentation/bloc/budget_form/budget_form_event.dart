part of 'budget_form_bloc.dart';

sealed class BudgetFormEvent extends Equatable {
  const BudgetFormEvent();

  @override
  List<Object?> get props => [];
}

final class BudgetFormLoadRequested extends BudgetFormEvent {
  const BudgetFormLoadRequested({
    this.budgetId,
    this.initialType,
  });

  final String? budgetId;
  final BudgetType? initialType;

  @override
  List<Object?> get props => [budgetId, initialType];
}

final class BudgetFormSubmitted extends BudgetFormEvent {
  const BudgetFormSubmitted({
    required this.name,
    required this.amount,
  });

  final String name;
  final double amount;

  @override
  List<Object?> get props => [name, amount];
}

final class BudgetFormTypeChanged extends BudgetFormEvent {
  const BudgetFormTypeChanged(this.type);

  final BudgetType type;

  @override
  List<Object?> get props => [type];
}

final class BudgetFormCategoryChanged extends BudgetFormEvent {
  const BudgetFormCategoryChanged(this.categoryId);

  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class BudgetFormStartDateChanged extends BudgetFormEvent {
  const BudgetFormStartDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class BudgetFormEndDateChanged extends BudgetFormEvent {
  const BudgetFormEndDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}
