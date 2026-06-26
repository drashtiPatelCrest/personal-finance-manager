import 'package:drift/drift.dart';

import 'categories_table.dart';

class RecurringTransactions extends Table {
  TextColumn get id => text()();

  TextColumn get categoryId =>
      text().references(Categories, #id, onDelete: KeyAction.restrict)();

  TextColumn get type => text()();

  RealColumn get amount => real()();

  TextColumn get frequency => text()();

  DateTimeColumn get nextExecutionDate => dateTime()();

  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();

  TextColumn get note => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
