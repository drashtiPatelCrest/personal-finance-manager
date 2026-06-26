part of 'settings_bloc.dart';

final class SettingsState extends BaseState {
  const SettingsState({
    super.status = BaseStatus.initial,
    super.message,
    this.preferences = const UserPreferences(
      themeMode: AppThemeMode.system,
      currencyCode: 'USD',
      localeCode: 'en',
    ),
    this.errorCode,
    this.errorNonce = 0,
    this.isDeletingAccount = false,
    this.accountDeleted = false,
    this.accountDeletedNonce = 0,
  });

  final UserPreferences preferences;
  final SettingsErrorCode? errorCode;
  final int errorNonce;
  final bool isDeletingAccount;
  final bool accountDeleted;
  final int accountDeletedNonce;

  SettingsState copyWith({
    BaseStatus? status,
    String? message,
    UserPreferences? preferences,
    SettingsErrorCode? errorCode,
    int? errorNonce,
    bool? isDeletingAccount,
    bool? accountDeleted,
    int? accountDeletedNonce,
    bool clearError = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      message: message ?? this.message,
      preferences: preferences ?? this.preferences,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      accountDeleted: accountDeleted ?? this.accountDeleted,
      accountDeletedNonce: accountDeletedNonce ?? this.accountDeletedNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        preferences,
        errorCode,
        errorNonce,
        isDeletingAccount,
        accountDeleted,
        accountDeletedNonce,
      ];
}
