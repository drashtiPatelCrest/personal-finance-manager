import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get email => text().withLength(min: 1, max: 255).unique()();

  TextColumn get passwordHash => text()();

  TextColumn get salt => text()();

  TextColumn get displayName => text().withLength(min: 1, max: 100)();

  TextColumn get securityAnswerHash => text()();

  TextColumn get securityAnswerSalt => text()();

  DateTimeColumn get createdAt => dateTime()();
}
