import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/reports/domain/entities/financial_report.dart';
import 'package:personal_finance_manager/features/settings/domain/entities/export_preferences.dart';
import 'package:personal_finance_manager/features/settings/domain/entities/notification_preferences.dart';
import 'package:personal_finance_manager/features/settings/domain/entities/user_preferences.dart';

void main() {
  group('UserPreferences', () {
    test('supports value equality', () {
      const first = UserPreferences(
        themeMode: AppThemeMode.system,
        currencyCode: 'USD',
        localeCode: 'en',
        notifications: NotificationPreferences(),
        export: ExportPreferences(),
      );
      const second = UserPreferences(
        themeMode: AppThemeMode.system,
        currencyCode: 'USD',
        localeCode: 'en',
        notifications: NotificationPreferences(),
        export: ExportPreferences(),
      );

      expect(first, equals(second));
    });

    test('copyWith updates nested preferences', () {
      const preferences = UserPreferences(
        themeMode: AppThemeMode.light,
        currencyCode: 'USD',
        localeCode: 'en',
      );

      final updated = preferences.copyWith(
        export: const ExportPreferences(
          useDateFilter: true,
          dateRangePreset: ReportDateRangePreset.lastMonth,
        ),
      );

      expect(updated.export.useDateFilter, isTrue);
      expect(updated.export.dateRangePreset, ReportDateRangePreset.lastMonth);
    });
  });

  group('NotificationPreferences', () {
    test('defaults all notification toggles to enabled', () {
      const preferences = NotificationPreferences();

      expect(preferences.budgetWarningEnabled, isTrue);
      expect(preferences.monthlySummaryEnabled, isTrue);
    });
  });
}
