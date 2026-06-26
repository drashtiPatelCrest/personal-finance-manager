enum SettingsErrorCode {
  unknown,
  deleteAccountFailed,
}

class SettingsException implements Exception {
  const SettingsException(this.code);

  final SettingsErrorCode code;
}
