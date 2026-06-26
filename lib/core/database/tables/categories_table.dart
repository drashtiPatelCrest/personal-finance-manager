import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get type => text()();

  TextColumn get iconCode => text()();

  IntColumn get colorValue => integer()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
