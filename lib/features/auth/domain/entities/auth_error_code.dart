/// Local authentication error codes mapped to localized messages in the UI.
enum AuthErrorCode {
  invalidEmail,
  weakPassword,
  displayNameRequired,
  emailAlreadyExists,
  userNotFound,
  invalidCredentials,
  passwordsDoNotMatch,
  securityAnswerRequired,
  invalidSecurityAnswer,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.code);

  final AuthErrorCode code;
}
