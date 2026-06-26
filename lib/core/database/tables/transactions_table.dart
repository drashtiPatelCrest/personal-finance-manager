import 'package:drift/drift.dart';

import 'categories_table.dart';

class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get categoryId =>
      text().references(Categories, #id, onDelete: KeyAction.restrict)();

  TextColumn get type => text()();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
