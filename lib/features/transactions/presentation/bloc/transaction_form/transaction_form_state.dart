part of 'transaction_form_bloc.dart';

final class TransactionFormState extends BaseState {
  TransactionFormState({
    super.status = BaseStatus.initial,
    super.message,
    this.transactionId,
    this.type = TransactionType.expense,
    this.categories = const [],
    this.selectedCategoryId,
    this.date,
    this.isEditing = false,
    this.saved = false,
    this.initialAmount,
    this.initialNote,
    this.errorCode,
  });

  final String? transactionId;
  final TransactionType type;
  final List<Category> categories;
  final String? selectedCategoryId;
  final DateTime? date;
  final bool isEditing;
  final bool saved;
  final double? initialAmount;
  final String? initialNote;
  final TransactionErrorCode? errorCode;

  factory TransactionFormState.initial({
    TransactionType type = TransactionType.expense,
    List<Category> categories = const [],
    String? selectedCategoryId,
    DateTime? date,
  }) {
    return TransactionFormState(
      type: type,
      categories: categories,
      selectedCategoryId: selectedCategoryId,
      date: date,
    );
  }

  TransactionFormState copyWith({
    BaseStatus? status,
    String? message,
    String? transactionId,
    TransactionType? type,
    List<Category>? categories,
    String? selectedCategoryId,
    DateTime? date,
    bool? isEditing,
    bool? saved,
    double? initialAmount,
    String? initialNote,
    TransactionErrorCode? errorCode,
    bool clearError = false,
  }) {
    return TransactionFormState(
      status: status ?? this.status,
      message: message ?? this.message,
      transactionId: transactionId ?? this.transactionId,
      type: type ?? this.type,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      date: date ?? this.date,
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
        transactionId,
        type,
        categories,
        selectedCategoryId,
        date,
        isEditing,
        saved,
        initialAmount,
        initialNote,
        errorCode,
      ];
}
