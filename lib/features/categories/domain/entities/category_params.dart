import 'package:equatable/equatable.dart';

import 'category.dart';

class CreateCategoryParams extends Equatable {
  const CreateCategoryParams({
    required this.name,
    required this.type,
    required this.iconCode,
    required this.colorValue,
  });

  final String name;
  final CategoryType type;
  final String iconCode;
  final int colorValue;

  @override
  List<Object?> get props => [name, type, iconCode, colorValue];
}

class UpdateCategoryParams extends Equatable {
  const UpdateCategoryParams({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.colorValue,
  });

  final String id;
  final String name;
  final CategoryType type;
  final String iconCode;
  final int colorValue;

  @override
  List<Object?> get props => [id, name, type, iconCode, colorValue];
}

class DeleteCategoryParams extends Equatable {
  const DeleteCategoryParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class WatchCategoriesParams extends Equatable {
  const WatchCategoriesParams({this.type, this.query});

  final CategoryType? type;
  final String? query;

  @override
  List<Object?> get props => [type, query];
}

class GetCategoriesParams extends Equatable {
  const GetCategoriesParams({this.type, this.query});

  final CategoryType? type;
  final String? query;

  @override
  List<Object?> get props => [type, query];
}

class GetCategoryByIdParams extends Equatable {
  const GetCategoryByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
