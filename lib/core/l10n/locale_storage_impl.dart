import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/locale_constants.dart';
import 'locale_storage.dart';

@LazySingleton(as: LocaleStorage)
class LocaleStorageImpl implements LocaleStorage {
  LocaleStorageImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<String?> readLanguageCode() async {
    return _preferences.getString(LocaleConstants.preferenceKey);
  }

  @override
  Future<void> writeLanguageCode(String languageCode) async {
    await _preferences.setString(LocaleConstants.preferenceKey, languageCode);
  }

  @override
  Future<void> clearLanguageCode() async {
    await _preferences.remove(LocaleConstants.preferenceKey);
  }
}
