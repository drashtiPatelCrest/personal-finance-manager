import 'package:drift/drift.dart';

import 'categories_table.dart';

class Budgets extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  RealColumn get amount => real()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  TextColumn get categoryId =>
      text().nullable().references(Categories, #id, onDelete: KeyAction.restrict)();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
