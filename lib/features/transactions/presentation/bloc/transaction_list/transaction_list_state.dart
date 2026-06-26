part of 'transaction_list_bloc.dart';

final class TransactionListState extends BaseState {
  const TransactionListState({
    super.status = BaseStatus.initial,
    super.message,
    this.transactions = const [],
    this.categories = const [],
    this.selectedType,
    this.selectedCategoryId,
    this.startDate,
    this.endDate,
    this.searchQuery = '',
    this.dailySummary,
    this.monthlySummary,
    this.errorCode,
    this.errorNonce = 0,
  });

  final List<Transaction> transactions;
  final List<Category> categories;
  final TransactionType? selectedType;
  final String? selectedCategoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchQuery;
  final Map<String, num>? dailySummary;
  final Map<String, num>? monthlySummary;
  final TransactionErrorCode? errorCode;
  final int errorNonce;

  List<Category> get filteredCategories {
    if (selectedType == null) {
      return categories;
    }
    final categoryType = selectedType == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    return categories.where((category) => category.type == categoryType).toList();
  }

  TransactionListState copyWith({
    BaseStatus? status,
    String? message,
    List<Transaction>? transactions,
    List<Category>? categories,
    TransactionType? selectedType,
    String? selectedCategoryId,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    Map<String, num>? dailySummary,
    Map<String, num>? monthlySummary,
    TransactionErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
    bool clearSelectedType = false,
    bool clearSelectedCategoryId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return TransactionListState(
      status: status ?? this.status,
      message: message ?? this.message,
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      selectedType:
          clearSelectedType ? null : selectedType ?? this.selectedType,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
      dailySummary: dailySummary ?? this.dailySummary,
      monthlySummary: monthlySummary ?? this.monthlySummary,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        transactions,
        categories,
        selectedType,
        selectedCategoryId,
        startDate,
        endDate,
        searchQuery,
        dailySummary,
        monthlySummary,
        errorCode,
        errorNonce,
      ];
}
