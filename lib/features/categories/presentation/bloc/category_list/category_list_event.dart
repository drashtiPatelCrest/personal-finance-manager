part of 'category_list_bloc.dart';

sealed class CategoryListEvent extends Equatable {
  const CategoryListEvent();

  @override
  List<Object?> get props => [];
}

final class CategoryListStarted extends CategoryListEvent {
  const CategoryListStarted({this.initialType});

  final CategoryType? initialType;

  @override
  List<Object?> get props => [initialType];
}

final class CategoryListSearchChanged extends CategoryListEvent {
  const CategoryListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class CategoryListTypeFilterChanged extends CategoryListEvent {
  const CategoryListTypeFilterChanged(this.type);

  final CategoryType? type;

  @override
  List<Object?> get props => [type];
}

final class CategoryListDeleteRequested extends CategoryListEvent {
  const CategoryListDeleteRequested(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

final class CategoryListUpdated extends CategoryListEvent {
  const CategoryListUpdated(this.categories);

  final List<Category> categories;

  @override
  List<Object?> get props => [categories];
}

final class CategoryListFailed extends CategoryListEvent {
  const CategoryListFailed(this.errorCode);

  final CategoryErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
