import 'package:injectable/injectable.dart';

import '../../domain/entities/user_preferences.dart';
import '../../domain/repository/settings_repository.dart';
import '../datasource/settings_local_datasource.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<UserPreferences> getPreferences() {
    return _localDataSource.getPreferences();
  }

  @override
  Future<void> savePreferences(UserPreferences preferences) {
    return _localDataSource.savePreferences(preferences);
  }

  @override
  Stream<UserPreferences> watchPreferences() {
    return _localDataSource.watchPreferences();
  }

  @override
  Future<void> clearPreferences() {
    return _localDataSource.clearPreferences();
  }
}
