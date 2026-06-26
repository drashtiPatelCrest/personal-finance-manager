part of 'budget_form_bloc.dart';

final class BudgetFormState extends BaseState {
  BudgetFormState({
    super.status = BaseStatus.initial,
    super.message,
    this.budgetId,
    this.type = BudgetType.overall,
    this.categories = const [],
    this.selectedCategoryId,
    this.startDate,
    this.endDate,
    this.isEditing = false,
    this.saved = false,
    this.initialName,
    this.initialAmount,
    this.errorCode,
  });

  final String? budgetId;
  final BudgetType type;
  final List<Category> categories;
  final String? selectedCategoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isEditing;
  final bool saved;
  final String? initialName;
  final double? initialAmount;
  final BudgetErrorCode? errorCode;

  factory BudgetFormState.initial({
    BudgetType type = BudgetType.overall,
    List<Category> categories = const [],
    String? selectedCategoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetFormState(
      type: type,
      categories: categories,
      selectedCategoryId: selectedCategoryId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  BudgetFormState copyWith({
    BaseStatus? status,
    String? message,
    String? budgetId,
    BudgetType? type,
    List<Category>? categories,
    String? selectedCategoryId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isEditing,
    bool? saved,
    String? initialName,
    double? initialAmount,
    BudgetErrorCode? errorCode,
    bool clearError = false,
    bool clearSelectedCategoryId = false,
  }) {
    return BudgetFormState(
      status: status ?? this.status,
      message: message ?? this.message,
      budgetId: budgetId ?? this.budgetId,
      type: type ?? this.type,
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isEditing: isEditing ?? this.isEditing,
      saved: saved ?? this.saved,
      initialName: initialName ?? this.initialName,
      initialAmount: initialAmount ?? this.initialAmount,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        budgetId,
        type,
        categories,
        selectedCategoryId,
        startDate,
        endDate,
        isEditing,
        saved,
        initialName,
        initialAmount,
        errorCode,
      ];
}
