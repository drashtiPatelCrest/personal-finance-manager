import 'package:equatable/equatable.dart';

enum CategoryType { income, expense }

class Category extends Equatable {
  const Category({
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
