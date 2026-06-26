part of 'category_form_bloc.dart';

sealed class CategoryFormEvent extends Equatable {
  const CategoryFormEvent();

  @override
  List<Object?> get props => [];
}

final class CategoryFormLoadRequested extends CategoryFormEvent {
  const CategoryFormLoadRequested({
    this.categoryId,
    this.initialType,
  });

  final String? categoryId;
  final CategoryType? initialType;

  @override
  List<Object?> get props => [categoryId, initialType];
}

final class CategoryFormSubmitted extends CategoryFormEvent {
  const CategoryFormSubmitted({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

final class CategoryFormIconChanged extends CategoryFormEvent {
  const CategoryFormIconChanged(this.iconCode);

  final String iconCode;

  @override
  List<Object?> get props => [iconCode];
}

final class CategoryFormColorChanged extends CategoryFormEvent {
  const CategoryFormColorChanged(this.colorValue);

  final int colorValue;

  @override
  List<Object?> get props => [colorValue];
}

final class CategoryFormTypeChanged extends CategoryFormEvent {
  const CategoryFormTypeChanged(this.type);

  final CategoryType type;

  @override
  List<Object?> get props => [type];
}
