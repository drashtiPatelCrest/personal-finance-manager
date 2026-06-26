import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/constants/settings_constants.dart';
import 'package:personal_finance_manager/features/reports/domain/entities/financial_report.dart';
import 'package:personal_finance_manager/features/settings/data/datasource/settings_local_datasource.dart';
import 'package:personal_finance_manager/features/settings/domain/entities/export_preferences.dart';
import 'package:personal_finance_manager/features/settings/domain/entities/notification_preferences.dart';
import 'package:personal_finance_manager/features/settings/domain/entities/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;
  late SettingsLocalDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    dataSource = SettingsLocalDataSource(preferences);
  });

  test('getPreferences returns defaults when nothing is saved', () async {
    final result = await dataSource.getPreferences();

    expect(result.themeMode, AppThemeMode.system);
    expect(result.currencyCode, 'USD');
    expect(result.localeCode, 'en');
    expect(result.notifications.budgetWarningEnabled, isTrue);
    expect(result.export.useDateFilter, isFalse);
  });

  test('savePreferences persists and emits updates', () async {
    const saved = UserPreferences(
      themeMode: AppThemeMode.dark,
      currencyCode: 'EUR',
      localeCode: 'en',
      notifications: NotificationPreferences(
        budgetWarningEnabled: false,
        monthlySummaryEnabled: false,
      ),
      export: ExportPreferences(
        useDateFilter: true,
        dateRangePreset: ReportDateRangePreset.thisYear,
      ),
    );

    final updates = <UserPreferences>[];
    final subscription = dataSource.watchPreferences().listen(updates.add);

    await dataSource.savePreferences(saved);
    final loaded = await dataSource.getPreferences();

    expect(loaded.themeMode, AppThemeMode.dark);
    expect(loaded.currencyCode, 'EUR');
    expect(loaded.notifications.budgetWarningEnabled, isFalse);
    expect(loaded.export.useDateFilter, isTrue);
    expect(loaded.export.dateRangePreset, ReportDateRangePreset.thisYear);
    expect(updates, isNotEmpty);

    await subscription.cancel();
  });

  test('clearPreferences removes saved values', () async {
    await dataSource.savePreferences(
      const UserPreferences(
        themeMode: AppThemeMode.light,
        currencyCode: 'GBP',
        localeCode: 'en',
      ),
    );

    await dataSource.clearPreferences();
    final loaded = await dataSource.getPreferences();

    expect(
      preferences.containsKey(SettingsConstants.currencyCodeKey),
      isFalse,
    );
    expect(loaded.currencyCode, 'USD');
    expect(loaded.themeMode, AppThemeMode.system);
  });
}
