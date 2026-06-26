part of 'category_list_bloc.dart';

final class CategoryListState extends BaseState {
  const CategoryListState({
    super.status = BaseStatus.initial,
    super.message,
    this.categories = const [],
    this.selectedType,
    this.searchQuery = '',
    this.errorCode,
    this.errorNonce = 0,
  });

  final List<Category> categories;
  final CategoryType? selectedType;
  final String searchQuery;
  final CategoryErrorCode? errorCode;
  final int errorNonce;

  CategoryListState copyWith({
    BaseStatus? status,
    String? message,
    List<Category>? categories,
    CategoryType? selectedType,
    String? searchQuery,
    CategoryErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
    bool clearSelectedType = false,
  }) {
    return CategoryListState(
      status: status ?? this.status,
      message: message ?? this.message,
      categories: categories ?? this.categories,
      selectedType: clearSelectedType ? null : selectedType ?? this.selectedType,
      searchQuery: searchQuery ?? this.searchQuery,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        categories,
        selectedType,
        searchQuery,
        errorCode,
        errorNonce,
      ];
}
