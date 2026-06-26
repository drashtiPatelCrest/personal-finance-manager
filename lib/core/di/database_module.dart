import 'package:injectable/injectable.dart';

import '../database/app_database.dart';

@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();
}
