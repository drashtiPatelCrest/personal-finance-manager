abstract class LocaleStorage {
  Future<String?> readLanguageCode();

  Future<void> writeLanguageCode(String languageCode);

  Future<void> clearLanguageCode();
}
