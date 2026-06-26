import '../../../../core/constants/currency_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/settings_error_code.dart';
import '../../domain/entities/user_preferences.dart';
import '../bloc/settings/settings_bloc.dart';

extension SettingsErrorLocalization on SettingsErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      SettingsErrorCode.unknown => l10n.settingsErrorUnknown,
      SettingsErrorCode.deleteAccountFailed =>
        l10n.settingsErrorDeleteAccountFailed,
    };
  }
}

extension AppThemeModeLocalization on AppThemeMode {
  String label(AppLocalizations l10n) {
    return switch (this) {
      AppThemeMode.light => l10n.settingsThemeLight,
      AppThemeMode.dark => l10n.settingsThemeDark,
      AppThemeMode.system => l10n.settingsThemeSystem,
    };
  }
}

extension SettingsNotificationLocalization on SettingsNotificationType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      SettingsNotificationType.budgetWarning =>
        l10n.settingsNotificationBudgetWarning,
      SettingsNotificationType.budgetExceeded =>
        l10n.settingsNotificationBudgetExceeded,
      SettingsNotificationType.goalReminder =>
        l10n.settingsNotificationGoalReminder,
      SettingsNotificationType.goalDeadline =>
        l10n.settingsNotificationGoalDeadline,
      SettingsNotificationType.recurringReminder =>
        l10n.settingsNotificationRecurringReminder,
      SettingsNotificationType.monthlySummary =>
        l10n.settingsNotificationMonthlySummary,
    };
  }
}

extension CurrencyOptionLocalization on CurrencyOption {
  String label(AppLocalizations l10n) {
    return switch (nameKey) {
      'settingsCurrencyUsd' => l10n.settingsCurrencyUsd,
      'settingsCurrencyEur' => l10n.settingsCurrencyEur,
      'settingsCurrencyGbp' => l10n.settingsCurrencyGbp,
      'settingsCurrencyInr' => l10n.settingsCurrencyInr,
      'settingsCurrencyJpy' => l10n.settingsCurrencyJpy,
      'settingsCurrencyCad' => l10n.settingsCurrencyCad,
      'settingsCurrencyAud' => l10n.settingsCurrencyAud,
      _ => code,
    };
  }
}
