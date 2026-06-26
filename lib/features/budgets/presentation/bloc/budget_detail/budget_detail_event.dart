part of 'budget_detail_bloc.dart';

sealed class BudgetDetailEvent extends Equatable {
  const BudgetDetailEvent();

  @override
  List<Object?> get props => [];
}

final class BudgetDetailLoadRequested extends BudgetDetailEvent {
  const BudgetDetailLoadRequested(this.budgetId);

  final String budgetId;

  @override
  List<Object?> get props => [budgetId];
}

final class BudgetDetailDeleteRequested extends BudgetDetailEvent {
  const BudgetDetailDeleteRequested(this.budgetId);

  final String budgetId;

  @override
  List<Object?> get props => [budgetId];
}

final class BudgetDetailTransactionsUpdated extends BudgetDetailEvent {
  const BudgetDetailTransactionsUpdated();
}
