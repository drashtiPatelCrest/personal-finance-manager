import 'package:drift/drift.dart';

class SavingsGoals extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  RealColumn get targetAmount => real()();

  RealColumn get currentAmount => real().withDefault(const Constant(0))();

  DateTimeColumn get deadline => dateTime()();

  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
