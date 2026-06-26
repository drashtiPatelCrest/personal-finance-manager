import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'locale_service.dart';
import 'locale_state.dart';

@lazySingleton
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._localeService)
      : super(LocaleState(locale: _localeService.defaultLocale));

  final LocaleService _localeService;

  Future<void> load({required Iterable<Locale> deviceLocales}) async {
    final locale = await _localeService.resolveInitialLocale(
      deviceLocales: deviceLocales,
    );
    emit(LocaleState(locale: locale));
  }

  Future<void> setLocale(Locale locale) async {
    final resolvedLocale = await _localeService.setLocale(locale);
    emit(LocaleState(locale: resolvedLocale));
  }

  Future<void> resetToSystemLocale({
    required Iterable<Locale> deviceLocales,
  }) async {
    final locale = await _localeService.clearSavedLocale(
      deviceLocales: deviceLocales,
    );
    emit(LocaleState(locale: locale));
  }
}
