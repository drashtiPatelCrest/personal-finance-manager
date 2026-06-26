part of 'recurring_form_bloc.dart';

final class RecurringFormState extends BaseState {
  RecurringFormState({
    super.status = BaseStatus.initial,
    super.message,
    this.recurringId,
    this.type = TransactionType.expense,
    this.categories = const [],
    this.selectedCategoryId,
    this.frequency = RecurrenceFrequency.monthly,
    this.nextExecutionDate,
    this.isEditing = false,
    this.saved = false,
    this.initialAmount,
    this.initialNote,
    this.errorCode,
  });

  final String? recurringId;
  final TransactionType type;
  final List<Category> categories;
  final String? selectedCategoryId;
  final RecurrenceFrequency frequency;
  final DateTime? nextExecutionDate;
  final bool isEditing;
  final bool saved;
  final double? initialAmount;
  final String? initialNote;
  final RecurringTransactionErrorCode? errorCode;

  factory RecurringFormState.initial({
    TransactionType type = TransactionType.expense,
    List<Category> categories = const [],
    String? selectedCategoryId,
    DateTime? nextExecutionDate,
  }) {
    return RecurringFormState(
      type: type,
      categories: categories,
      selectedCategoryId: selectedCategoryId,
      nextExecutionDate: nextExecutionDate,
    );
  }

  RecurringFormState copyWith({
    BaseStatus? status,
    String? message,
    String? recurringId,
    TransactionType? type,
    List<Category>? categories,
    String? selectedCategoryId,
    RecurrenceFrequency? frequency,
    DateTime? nextExecutionDate,
    bool? isEditing,
    bool? saved,
    double? initialAmount,
    String? initialNote,
    RecurringTransactionErrorCode? errorCode,
    bool clearError = false,
  }) {
    return RecurringFormState(
      status: status ?? this.status,
      message: message ?? this.message,
      recurringId: recurringId ?? this.recurringId,
      type: type ?? this.type,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      frequency: frequency ?? this.frequency,
      nextExecutionDate: nextExecutionDate ?? this.nextExecutionDate,
      isEditing: isEditing ?? this.isEditing,
      saved: saved ?? this.saved,
      initialAmount: initialAmount ?? this.initialAmount,
      initialNote: initialNote ?? this.initialNote,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        recurringId,
        type,
        categories,
        selectedCategoryId,
        frequency,
        nextExecutionDate,
        isEditing,
        saved,
        initialAmount,
        initialNote,
        errorCode,
      ];
}
