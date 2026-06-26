part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

final class SettingsPreferencesUpdated extends SettingsEvent {
  const SettingsPreferencesUpdated(this.preferences);

  final UserPreferences preferences;

  @override
  List<Object?> get props => [preferences];
}

final class SettingsThemeModeChanged extends SettingsEvent {
  const SettingsThemeModeChanged(this.themeMode);

  final AppThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

final class SettingsCurrencyChanged extends SettingsEvent {
  const SettingsCurrencyChanged(this.currencyCode);

  final String currencyCode;

  @override
  List<Object?> get props => [currencyCode];
}

final class SettingsLocaleChanged extends SettingsEvent {
  const SettingsLocaleChanged(this.locale);

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}

enum SettingsNotificationType {
  budgetWarning,
  budgetExceeded,
  goalReminder,
  goalDeadline,
  recurringReminder,
  monthlySummary,
}

final class SettingsNotificationToggled extends SettingsEvent {
  const SettingsNotificationToggled({
    required this.type,
    required this.enabled,
  });

  final SettingsNotificationType type;
  final bool enabled;

  @override
  List<Object?> get props => [type, enabled];
}

final class SettingsExportDateFilterToggled extends SettingsEvent {
  const SettingsExportDateFilterToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class SettingsExportDateRangeChanged extends SettingsEvent {
  const SettingsExportDateRangeChanged(this.preset);

  final ReportDateRangePreset preset;

  @override
  List<Object?> get props => [preset];
}

final class SettingsDeleteAccountRequested extends SettingsEvent {
  const SettingsDeleteAccountRequested({required this.userId});

  final int userId;

  @override
  List<Object?> get props => [userId];
}
