import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../features/settings/domain/entities/user_preferences.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.themeMode});

  final AppThemeMode themeMode;

  ThemeMode get materialThemeMode {
    return switch (themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  @override
  List<Object?> get props => [themeMode];
}
