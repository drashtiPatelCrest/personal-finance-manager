part of 'recurring_list_bloc.dart';

final class RecurringListState extends BaseState {
  const RecurringListState({
    super.status = BaseStatus.initial,
    super.message,
    this.items = const [],
    this.selectedPaused,
    this.searchQuery = '',
    this.errorCode,
    this.errorNonce = 0,
  });

  final List<RecurringTransaction> items;
  final bool? selectedPaused;
  final String searchQuery;
  final RecurringTransactionErrorCode? errorCode;
  final int errorNonce;

  RecurringListState copyWith({
    BaseStatus? status,
    String? message,
    List<RecurringTransaction>? items,
    bool? selectedPaused,
    String? searchQuery,
    RecurringTransactionErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
    bool clearSelectedPaused = false,
  }) {
    return RecurringListState(
      status: status ?? this.status,
      message: message ?? this.message,
      items: items ?? this.items,
      selectedPaused:
          clearSelectedPaused ? null : selectedPaused ?? this.selectedPaused,
      searchQuery: searchQuery ?? this.searchQuery,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        items,
        selectedPaused,
        searchQuery,
        errorCode,
        errorNonce,
      ];
}
