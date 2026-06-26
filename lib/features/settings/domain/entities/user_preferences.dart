import 'package:equatable/equatable.dart';

import 'export_preferences.dart';
import 'notification_preferences.dart';

enum AppThemeMode { light, dark, system }

class UserPreferences extends Equatable {
  const UserPreferences({
    required this.themeMode,
    required this.currencyCode,
    required this.localeCode,
    this.notifications = const NotificationPreferences(),
    this.export = const ExportPreferences(),
  });

  final AppThemeMode themeMode;
  final String currencyCode;
  final String localeCode;
  final NotificationPreferences notifications;
  final ExportPreferences export;

  UserPreferences copyWith({
    AppThemeMode? themeMode,
    String? currencyCode,
    String? localeCode,
    NotificationPreferences? notifications,
    ExportPreferences? export,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      currencyCode: currencyCode ?? this.currencyCode,
      localeCode: localeCode ?? this.localeCode,
      notifications: notifications ?? this.notifications,
      export: export ?? this.export,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        currencyCode,
        localeCode,
        notifications,
        export,
      ];
}
