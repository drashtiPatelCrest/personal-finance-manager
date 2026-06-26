import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../../core/l10n/locale_service.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../auth/domain/entities/auth_error_code.dart';
import '../../../../auth/domain/usecases/auth_usecases.dart';
import '../../../../reports/domain/entities/financial_report.dart';
import '../../../domain/entities/settings_error_code.dart';
import '../../../domain/entities/user_preferences.dart';
import '../../../domain/usecases/settings_usecases.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
    this._getPreferencesUseCase,
    this._savePreferencesUseCase,
    this._watchPreferencesUseCase,
    this._deleteAccountUseCase,
    this._localeService,
  ) : super(const SettingsState()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsPreferencesUpdated>(_onPreferencesUpdated);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
    on<SettingsCurrencyChanged>(_onCurrencyChanged);
    on<SettingsLocaleChanged>(_onLocaleChanged);
    on<SettingsNotificationToggled>(_onNotificationToggled);
    on<SettingsExportDateFilterToggled>(_onExportDateFilterToggled);
    on<SettingsExportDateRangeChanged>(_onExportDateRangeChanged);
    on<SettingsDeleteAccountRequested>(_onDeleteAccountRequested);
  }

  final GetPreferencesUseCase _getPreferencesUseCase;
  final SavePreferencesUseCase _savePreferencesUseCase;
  final WatchPreferencesUseCase _watchPreferencesUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final LocaleService _localeService;
  StreamSubscription<UserPreferences>? _subscription;

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      final preferences = await _getPreferencesUseCase(const NoParams());
      emit(
        state.copyWith(
          status: BaseStatus.success,
          preferences: preferences,
          clearError: true,
        ),
      );

      await _subscription?.cancel();
      final stream = await _watchPreferencesUseCase(const NoParams());
      _subscription = stream.listen(
        (preferences) => add(SettingsPreferencesUpdated(preferences)),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: SettingsErrorCode.unknown,
        ),
      );
    }
  }

  void _onPreferencesUpdated(
    SettingsPreferencesUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        preferences: event.preferences,
      ),
    );
  }

  Future<void> _onThemeModeChanged(
    SettingsThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _updatePreferences(
      emit,
      state.preferences.copyWith(themeMode: event.themeMode),
    );
  }

  Future<void> _onCurrencyChanged(
    SettingsCurrencyChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _updatePreferences(
      emit,
      state.preferences.copyWith(currencyCode: event.currencyCode),
    );
  }

  Future<void> _onLocaleChanged(
    SettingsLocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final locale = await _localeService.setLocale(event.locale);
    await _updatePreferences(
      emit,
      state.preferences.copyWith(localeCode: locale.languageCode),
    );
  }

  Future<void> _onNotificationToggled(
    SettingsNotificationToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final notifications = state.preferences.notifications;
    final updated = switch (event.type) {
      SettingsNotificationType.budgetWarning => notifications.copyWith(
          budgetWarningEnabled: event.enabled,
        ),
      SettingsNotificationType.budgetExceeded => notifications.copyWith(
          budgetExceededEnabled: event.enabled,
        ),
      SettingsNotificationType.goalReminder => notifications.copyWith(
          goalReminderEnabled: event.enabled,
        ),
      SettingsNotificationType.goalDeadline => notifications.copyWith(
          goalDeadlineEnabled: event.enabled,
        ),
      SettingsNotificationType.recurringReminder => notifications.copyWith(
          recurringReminderEnabled: event.enabled,
        ),
      SettingsNotificationType.monthlySummary => notifications.copyWith(
          monthlySummaryEnabled: event.enabled,
        ),
    };

    await _updatePreferences(
      emit,
      state.preferences.copyWith(notifications: updated),
    );
  }

  Future<void> _onExportDateFilterToggled(
    SettingsExportDateFilterToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final export = state.preferences.export.copyWith(
      useDateFilter: event.enabled,
    );
    await _updatePreferences(
      emit,
      state.preferences.copyWith(export: export),
    );
  }

  Future<void> _onExportDateRangeChanged(
    SettingsExportDateRangeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final export = state.preferences.export.copyWith(
      dateRangePreset: event.preset,
    );
    await _updatePreferences(
      emit,
      state.preferences.copyWith(export: export),
    );
  }

  Future<void> _onDeleteAccountRequested(
    SettingsDeleteAccountRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isDeletingAccount: true, clearError: true));

    try {
      await _deleteAccountUseCase(
        DeleteAccountParams(userId: event.userId),
      );
      emit(
        state.copyWith(
          isDeletingAccount: false,
          accountDeleted: true,
          accountDeletedNonce: state.accountDeletedNonce + 1,
        ),
      );
    } on AuthException {
      emit(
        state.copyWith(
          isDeletingAccount: false,
          errorCode: SettingsErrorCode.deleteAccountFailed,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isDeletingAccount: false,
          errorCode: SettingsErrorCode.deleteAccountFailed,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _updatePreferences(
    Emitter<SettingsState> emit,
    UserPreferences preferences,
  ) async {
    try {
      final latest = await _getPreferencesUseCase(const NoParams());
      final merged = latest.copyWith(
        notifications: preferences.notifications,
        export: preferences.export,
        localeCode: preferences.localeCode,
      );
      await _savePreferencesUseCase(
        SavePreferencesParams(preferences: merged),
      );
      emit(state.copyWith(preferences: merged, clearError: true));
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: SettingsErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
