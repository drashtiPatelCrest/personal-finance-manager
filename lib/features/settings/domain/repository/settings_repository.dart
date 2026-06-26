import '../entities/user_preferences.dart';

abstract class SettingsRepository {
  Future<UserPreferences> getPreferences();

  Future<void> savePreferences(UserPreferences preferences);

  Stream<UserPreferences> watchPreferences();

  Future<void> clearPreferences();
}
