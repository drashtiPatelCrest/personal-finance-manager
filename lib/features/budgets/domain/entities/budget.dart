import 'package:equatable/equatable.dart';

enum BudgetType { overall, category }

enum BudgetStatus { normal, warning, exceeded }

class Budget extends Equatable {
  const Budget({
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

  BudgetType get type =>
      categoryId == null ? BudgetType.overall : BudgetType.category;

  @override
  List<Object?> get props => [id, name, amount, startDate, endDate, categoryId];
}

class BudgetUsage extends Equatable {
  const BudgetUsage({
    required this.budget,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usagePercentage,
    this.categoryName,
  });

  final Budget budget;
  final double spentAmount;
  final double remainingAmount;
  final double usagePercentage;
  final String? categoryName;

  BudgetStatus get status {
    if (usagePercentage >= 100) {
      return BudgetStatus.exceeded;
    }
    if (usagePercentage >= 80) {
      return BudgetStatus.warning;
    }
    return BudgetStatus.normal;
  }

  @override
  List<Object?> get props =>
      [budget, spentAmount, remainingAmount, usagePercentage, categoryName];
}
