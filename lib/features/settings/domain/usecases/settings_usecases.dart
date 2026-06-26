import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/export_preferences.dart';
import '../entities/notification_preferences.dart';
import '../entities/user_preferences.dart';
import '../repository/settings_repository.dart';

@injectable
class GetPreferencesUseCase implements UseCase<UserPreferences, NoParams> {
  GetPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<UserPreferences> call(NoParams params) {
    return _repository.getPreferences();
  }
}

@injectable
class SavePreferencesUseCase
    implements UseCase<void, SavePreferencesParams> {
  SavePreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(SavePreferencesParams params) {
    return _repository.savePreferences(params.preferences);
  }
}

@injectable
class WatchPreferencesUseCase
    implements UseCase<Stream<UserPreferences>, NoParams> {
  WatchPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Stream<UserPreferences>> call(NoParams params) async {
    return _repository.watchPreferences();
  }
}

@injectable
class ClearPreferencesUseCase implements UseCase<void, NoParams> {
  ClearPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(NoParams params) {
    return _repository.clearPreferences();
  }
}

class SavePreferencesParams {
  const SavePreferencesParams({required this.preferences});

  final UserPreferences preferences;
}

class UpdateThemeModeParams {
  const UpdateThemeModeParams({required this.themeMode});

  final AppThemeMode themeMode;
}

@injectable
class UpdateThemeModeUseCase
    implements UseCase<UserPreferences, UpdateThemeModeParams> {
  UpdateThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<UserPreferences> call(UpdateThemeModeParams params) async {
    final current = await _repository.getPreferences();
    final updated = current.copyWith(themeMode: params.themeMode);
    await _repository.savePreferences(updated);
    return updated;
  }
}

class UpdateCurrencyParams {
  const UpdateCurrencyParams({required this.currencyCode});

  final String currencyCode;
}

@injectable
class UpdateCurrencyUseCase
    implements UseCase<UserPreferences, UpdateCurrencyParams> {
  UpdateCurrencyUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<UserPreferences> call(UpdateCurrencyParams params) async {
    final current = await _repository.getPreferences();
    final updated = current.copyWith(currencyCode: params.currencyCode);
    await _repository.savePreferences(updated);
    return updated;
  }
}

class UpdateNotificationPreferencesParams {
  const UpdateNotificationPreferencesParams({
    required this.notifications,
  });

  final NotificationPreferences notifications;
}

@injectable
class UpdateNotificationPreferencesUseCase
    implements UseCase<UserPreferences, UpdateNotificationPreferencesParams> {
  UpdateNotificationPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<UserPreferences> call(
    UpdateNotificationPreferencesParams params,
  ) async {
    final current = await _repository.getPreferences();
    final updated = current.copyWith(notifications: params.notifications);
    await _repository.savePreferences(updated);
    return updated;
  }
}

class UpdateExportPreferencesParams {
  const UpdateExportPreferencesParams({required this.export});

  final ExportPreferences export;
}

@injectable
class UpdateExportPreferencesUseCase
    implements UseCase<UserPreferences, UpdateExportPreferencesParams> {
  UpdateExportPreferencesUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<UserPreferences> call(UpdateExportPreferencesParams params) async {
    final current = await _repository.getPreferences();
    final updated = current.copyWith(export: params.export);
    await _repository.savePreferences(updated);
    return updated;
  }
}
