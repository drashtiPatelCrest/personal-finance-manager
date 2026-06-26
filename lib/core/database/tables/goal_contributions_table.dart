import 'package:drift/drift.dart';

import 'savings_goals_table.dart';

class GoalContributions extends Table {
  TextColumn get id => text()();

  TextColumn get goalId =>
      text().references(SavingsGoals, #id, onDelete: KeyAction.cascade)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
