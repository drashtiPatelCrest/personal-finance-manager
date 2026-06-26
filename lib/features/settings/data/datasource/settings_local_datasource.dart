import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/currency_constants.dart';
import '../../../../core/constants/locale_constants.dart';
import '../../../../core/constants/settings_constants.dart';
import '../../../reports/domain/entities/financial_report.dart';
import '../../domain/entities/export_preferences.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/user_preferences.dart';

@lazySingleton
class SettingsLocalDataSource {
  SettingsLocalDataSource(this._preferences);

  final SharedPreferences _preferences;
  final StreamController<UserPreferences> _controller =
      StreamController<UserPreferences>.broadcast();

  Stream<UserPreferences> watchPreferences() {
    return _controller.stream;
  }

  Future<UserPreferences> getPreferences() async {
    return _readPreferences();
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    await _preferences.setString(
      SettingsConstants.themeModeKey,
      preferences.themeMode.name,
    );
    await _preferences.setString(
      SettingsConstants.currencyCodeKey,
      preferences.currencyCode,
    );
    await _preferences.setString(
      LocaleConstants.preferenceKey,
      preferences.localeCode,
    );

    final notifications = preferences.notifications;
    await _preferences.setBool(
      SettingsConstants.notificationBudgetWarningKey,
      notifications.budgetWarningEnabled,
    );
    await _preferences.setBool(
      SettingsConstants.notificationBudgetExceededKey,
      notifications.budgetExceededEnabled,
    );
    await _preferences.setBool(
      SettingsConstants.notificationGoalReminderKey,
      notifications.goalReminderEnabled,
    );
    await _preferences.setBool(
      SettingsConstants.notificationGoalDeadlineKey,
      notifications.goalDeadlineEnabled,
    );
    await _preferences.setBool(
      SettingsConstants.notificationRecurringReminderKey,
      notifications.recurringReminderEnabled,
    );
    await _preferences.setBool(
      SettingsConstants.notificationMonthlySummaryKey,
      notifications.monthlySummaryEnabled,
    );

    final export = preferences.export;
    await _preferences.setBool(
      SettingsConstants.exportUseDateFilterKey,
      export.useDateFilter,
    );
    await _preferences.setString(
      SettingsConstants.exportDateRangePresetKey,
      export.dateRangePreset.name,
    );

    _controller.add(preferences);
  }

  Future<void> clearPreferences() async {
    await _preferences.remove(SettingsConstants.themeModeKey);
    await _preferences.remove(SettingsConstants.currencyCodeKey);
    await _preferences.remove(SettingsConstants.notificationBudgetWarningKey);
    await _preferences.remove(SettingsConstants.notificationBudgetExceededKey);
    await _preferences.remove(SettingsConstants.notificationGoalReminderKey);
    await _preferences.remove(SettingsConstants.notificationGoalDeadlineKey);
    await _preferences.remove(
      SettingsConstants.notificationRecurringReminderKey,
    );
    await _preferences.remove(SettingsConstants.notificationMonthlySummaryKey);
    await _preferences.remove(SettingsConstants.exportUseDateFilterKey);
    await _preferences.remove(SettingsConstants.exportDateRangePresetKey);
    await _preferences.remove(LocaleConstants.preferenceKey);

    _controller.add(_readPreferences());
  }

  UserPreferences _readPreferences() {
    final themeModeName =
        _preferences.getString(SettingsConstants.themeModeKey);
    final themeMode = AppThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeName,
      orElse: () => AppThemeMode.system,
    );

    final currencyCode = _preferences.getString(
          SettingsConstants.currencyCodeKey,
        ) ??
        CurrencyConstants.defaultCurrencyCode;

    final localeCode = _preferences.getString(LocaleConstants.preferenceKey) ??
        'en';

    final notifications = NotificationPreferences(
      budgetWarningEnabled: _preferences.getBool(
            SettingsConstants.notificationBudgetWarningKey,
          ) ??
          true,
      budgetExceededEnabled: _preferences.getBool(
            SettingsConstants.notificationBudgetExceededKey,
          ) ??
          true,
      goalReminderEnabled: _preferences.getBool(
            SettingsConstants.notificationGoalReminderKey,
          ) ??
          true,
      goalDeadlineEnabled: _preferences.getBool(
            SettingsConstants.notificationGoalDeadlineKey,
          ) ??
          true,
      recurringReminderEnabled: _preferences.getBool(
            SettingsConstants.notificationRecurringReminderKey,
          ) ??
          true,
      monthlySummaryEnabled: _preferences.getBool(
            SettingsConstants.notificationMonthlySummaryKey,
          ) ??
          true,
    );

    final exportPresetName = _preferences.getString(
      SettingsConstants.exportDateRangePresetKey,
    );
    final dateRangePreset = ReportDateRangePreset.values.firstWhere(
      (preset) => preset.name == exportPresetName,
      orElse: () => ReportDateRangePreset.thisMonth,
    );

    final export = ExportPreferences(
      useDateFilter:
          _preferences.getBool(SettingsConstants.exportUseDateFilterKey) ??
              false,
      dateRangePreset: dateRangePreset,
    );

    return UserPreferences(
      themeMode: themeMode,
      currencyCode: currencyCode,
      localeCode: localeCode,
      notifications: notifications,
      export: export,
    );
  }

  @disposeMethod
  void dispose() {
    _controller.close();
  }
}
