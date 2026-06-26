part of 'budget_list_bloc.dart';

sealed class BudgetListEvent extends Equatable {
  const BudgetListEvent();

  @override
  List<Object?> get props => [];
}

final class BudgetListStarted extends BudgetListEvent {
  const BudgetListStarted();
}

final class BudgetListSearchChanged extends BudgetListEvent {
  const BudgetListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class BudgetListDeleteRequested extends BudgetListEvent {
  const BudgetListDeleteRequested(this.budgetId);

  final String budgetId;

  @override
  List<Object?> get props => [budgetId];
}

final class BudgetListUpdated extends BudgetListEvent {
  const BudgetListUpdated(this.budgets);

  final List<Budget> budgets;

  @override
  List<Object?> get props => [budgets];
}

final class BudgetListTransactionsUpdated extends BudgetListEvent {
  const BudgetListTransactionsUpdated();
}

final class BudgetListFailed extends BudgetListEvent {
  const BudgetListFailed(this.errorCode);

  final BudgetErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
