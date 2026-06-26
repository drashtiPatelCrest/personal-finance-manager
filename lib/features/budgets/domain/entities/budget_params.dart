import 'package:equatable/equatable.dart';

class CreateBudgetParams extends Equatable {
  const CreateBudgetParams({
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    this.categoryId,
  });

  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String? categoryId;

  @override
  List<Object?> get props =>
      [name, amount, startDate, endDate, categoryId];
}

class UpdateBudgetParams extends Equatable {
  const UpdateBudgetParams({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    this.categoryId,
  });

  final String id;
  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String? categoryId;

  @override
  List<Object?> get props =>
      [id, name, amount, startDate, endDate, categoryId];
}

class DeleteBudgetParams extends Equatable {
  const DeleteBudgetParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class WatchBudgetsParams extends Equatable {
  const WatchBudgetsParams({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}

class GetBudgetsParams extends Equatable {
  const GetBudgetsParams({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}

class GetBudgetByIdParams extends Equatable {
  const GetBudgetByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class GetBudgetUsageParams extends Equatable {
  const GetBudgetUsageParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
