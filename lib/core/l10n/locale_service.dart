import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'l10n_config.dart';
import 'locale_storage.dart';

@lazySingleton
class LocaleService {
  LocaleService(this._localeStorage);

  final LocaleStorage _localeStorage;

  List<Locale> get supportedLocales => L10nConfig.supportedLocales;

  Locale get defaultLocale => L10nConfig.defaultLocale;

  /// Returns the persisted locale, or `null` when no preference is saved.
  Future<Locale?> getSavedLocale() async {
    final languageCode = await _localeStorage.readLanguageCode();
    if (languageCode == null) {
      return null;
    }

    return L10nConfig.localeFromLanguageCode(languageCode);
  }

  /// Persists and returns the locale to apply in the UI.
  Future<Locale> setLocale(Locale locale) async {
    if (!L10nConfig.isSupported(locale)) {
      return defaultLocale;
    }

    await _localeStorage.writeLanguageCode(locale.languageCode);
    return locale;
  }

  /// Clears the saved preference so [L10nConfig.resolveLocale] can fall back
  /// to device locales or [defaultLocale].
  Future<Locale> clearSavedLocale({
    required Iterable<Locale> deviceLocales,
  }) async {
    await _localeStorage.clearLanguageCode();
    return L10nConfig.resolveLocale(
      savedLocale: null,
      deviceLocales: deviceLocales,
    );
  }

  /// Resolves the locale to use on startup.
  Future<Locale> resolveInitialLocale({
    required Iterable<Locale> deviceLocales,
  }) async {
    final savedLocale = await getSavedLocale();
    return L10nConfig.resolveLocale(
      savedLocale: savedLocale,
      deviceLocales: deviceLocales,
    );
  }
}
