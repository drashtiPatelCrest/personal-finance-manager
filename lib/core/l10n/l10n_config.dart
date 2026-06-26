import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Central localization configuration shared across the app.
abstract final class L10nConfig {
  static const Locale defaultLocale = Locale('en');

  /// Keep in sync with ARB files; [AppLocalizations] is the source of truth
  /// for code-generated supported locales.
  static List<Locale> get supportedLocales =>
      AppLocalizations.supportedLocales;

  static bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  static Locale? localeFromLanguageCode(String languageCode) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }

  /// Resolves the active locale using the saved preference, then device
  /// locales, then [defaultLocale].
  static Locale resolveLocale({
    required Locale? savedLocale,
    required Iterable<Locale> deviceLocales,
  }) {
    if (savedLocale != null && isSupported(savedLocale)) {
      return savedLocale;
    }

    for (final deviceLocale in deviceLocales) {
      if (isSupported(deviceLocale)) {
        return deviceLocale;
      }
    }

    return defaultLocale;
  }
}
