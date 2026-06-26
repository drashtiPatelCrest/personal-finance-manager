import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../features/settings/domain/entities/user_preferences.dart';
import '../../core/usecases/usecase.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import 'theme_state.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._getPreferencesUseCase, this._updateThemeModeUseCase)
      : super(const ThemeState(themeMode: AppThemeMode.system));

  final GetPreferencesUseCase _getPreferencesUseCase;
  final UpdateThemeModeUseCase _updateThemeModeUseCase;

  Future<void> load() async {
    final preferences = await _getPreferencesUseCase(const NoParams());
    emit(ThemeState(themeMode: preferences.themeMode));
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    final preferences = await _updateThemeModeUseCase(
      UpdateThemeModeParams(themeMode: themeMode),
    );
    emit(ThemeState(themeMode: preferences.themeMode));
  }
}
