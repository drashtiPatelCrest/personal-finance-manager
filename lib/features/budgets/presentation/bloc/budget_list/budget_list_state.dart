part of 'budget_list_bloc.dart';

final class BudgetListState extends BaseState {
  const BudgetListState({
    super.status = BaseStatus.initial,
    super.message,
    this.budgets = const [],
    this.usages = const {},
    this.searchQuery = '',
    this.errorCode,
    this.errorNonce = 0,
  });

  final List<Budget> budgets;
  final Map<String, BudgetUsage> usages;
  final String searchQuery;
  final BudgetErrorCode? errorCode;
  final int errorNonce;

  BudgetListState copyWith({
    BaseStatus? status,
    String? message,
    List<Budget>? budgets,
    Map<String, BudgetUsage>? usages,
    String? searchQuery,
    BudgetErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
  }) {
    return BudgetListState(
      status: status ?? this.status,
      message: message ?? this.message,
      budgets: budgets ?? this.budgets,
      usages: usages ?? this.usages,
      searchQuery: searchQuery ?? this.searchQuery,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        budgets,
        usages,
        searchQuery,
        errorCode,
        errorNonce,
      ];
}
