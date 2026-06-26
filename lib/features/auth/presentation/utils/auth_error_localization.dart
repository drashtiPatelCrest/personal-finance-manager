import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_error_code.dart';

extension AuthErrorLocalization on AuthErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      AuthErrorCode.invalidEmail => l10n.authErrorInvalidEmail,
      AuthErrorCode.weakPassword => l10n.authErrorWeakPassword,
      AuthErrorCode.displayNameRequired => l10n.authErrorDisplayNameRequired,
      AuthErrorCode.emailAlreadyExists => l10n.authErrorEmailAlreadyExists,
      AuthErrorCode.userNotFound => l10n.authErrorUserNotFound,
      AuthErrorCode.invalidCredentials => l10n.authErrorInvalidCredentials,
      AuthErrorCode.passwordsDoNotMatch => l10n.authErrorPasswordsDoNotMatch,
      AuthErrorCode.securityAnswerRequired => l10n.authErrorSecurityAnswerRequired,
      AuthErrorCode.invalidSecurityAnswer => l10n.authErrorInvalidSecurityAnswer,
      AuthErrorCode.unknown => l10n.authErrorUnknown,
    };
  }
}

extension AuthErrorContext on BuildContext {
  String authErrorMessage(AuthErrorCode code) => code.message(l10n);
}
