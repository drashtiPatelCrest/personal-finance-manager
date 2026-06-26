import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/auth_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/password_hasher.dart';
import '../../domain/entities/auth_error_code.dart';
import '../../domain/entities/auth_params.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';

@lazySingleton
class AuthLocalDataSource {
  AuthLocalDataSource(
    this._database,
    this._preferences,
    this._passwordHasher,
  );

  final AppDatabase _database;
  final SharedPreferences _preferences;
  final PasswordHasher _passwordHasher;

  Future<bool> hasRegisteredUsers() async {
    final count = await _database.authDao.countUsers();
    return count > 0;
  }

  Future<AuthenticatedSession?> getCurrentSession() async {
    final userId = _preferences.getInt(AuthConstants.sessionUserIdKey);
    if (userId == null) {
      return null;
    }

    final user = await _database.authDao.getUserById(userId);
    if (user == null) {
      await clearSession();
      return null;
    }

    return AuthenticatedSession(user: _mapUser(user));
  }

  Future<AuthenticatedSession> login(LoginParams params) async {
    _validateEmail(params.email);
    if (params.password.isEmpty) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }

    final email = params.email.trim().toLowerCase();
    final user = await _database.authDao.getUserByEmail(email);
    if (user == null) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }

    final isValid = await _passwordHasher.verifyPassword(
      password: params.password,
      salt: user.salt,
      expectedHash: user.passwordHash,
    );
    if (!isValid) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }

    final session = AuthenticatedSession(user: _mapUser(user));
    await _saveSession(session.user.id);
    return session;
  }

  Future<AuthenticatedSession> register(RegisterParams params) async {
    await _validateRegistration(params);

    final email = params.email.trim().toLowerCase();
    final existing = await _database.authDao.getUserByEmail(email);
    if (existing != null) {
      throw const AuthException(AuthErrorCode.emailAlreadyExists);
    }

    final salt = await _passwordHasher.generateSalt();
    final passwordHash = await _passwordHasher.hashPassword(
      password: params.password,
      salt: salt,
    );
    final securityAnswerSalt = await _passwordHasher.generateSalt();
    final securityAnswerHash = await _passwordHasher.hashPassword(
      password: _normalizeSecurityAnswer(params.securityAnswer),
      salt: securityAnswerSalt,
    );

    final userId = await _database.authDao.insertUser(
      UsersCompanion.insert(
        email: email,
        passwordHash: passwordHash,
        salt: salt,
        displayName: params.displayName.trim(),
        securityAnswerHash: securityAnswerHash,
        securityAnswerSalt: securityAnswerSalt,
        createdAt: DateTime.now(),
      ),
    );

    final user = await _database.authDao.getUserById(userId);
    if (user == null) {
      throw const AuthException(AuthErrorCode.unknown);
    }

    final session = AuthenticatedSession(user: _mapUser(user));
    await _saveSession(session.user.id);
    return session;
  }

  Future<void> resetPassword(ForgotPasswordParams params) async {
    await _validatePasswordReset(params);

    final email = params.email.trim().toLowerCase();
    final user = await _database.authDao.getUserByEmail(email);
    if (user == null) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }

    final isSecurityAnswerValid = await _passwordHasher.verifyPassword(
      password: _normalizeSecurityAnswer(params.securityAnswer),
      salt: user.securityAnswerSalt,
      expectedHash: user.securityAnswerHash,
    );
    if (!isSecurityAnswerValid) {
      throw const AuthException(AuthErrorCode.invalidSecurityAnswer);
    }

    final salt = await _passwordHasher.generateSalt();
    final passwordHash = await _passwordHasher.hashPassword(
      password: params.newPassword,
      salt: salt,
    );

    final updated = await _database.authDao.updatePassword(
      userId: user.id,
      passwordHash: passwordHash,
      salt: salt,
    );
    if (!updated) {
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  Future<void> clearSession() async {
    await _preferences.remove(AuthConstants.sessionUserIdKey);
  }

  Future<void> deleteAccount({required int userId}) async {
    final sessionUserId = _preferences.getInt(AuthConstants.sessionUserIdKey);
    if (sessionUserId == null || sessionUserId != userId) {
      throw const AuthException(AuthErrorCode.invalidCredentials);
    }

    final user = await _database.authDao.getUserById(userId);
    if (user == null) {
      throw const AuthException(AuthErrorCode.userNotFound);
    }

    await _database.wipeAllData();
    await clearSession();
  }

  Future<void> _saveSession(int userId) async {
    await _preferences.setInt(AuthConstants.sessionUserIdKey, userId);
  }

  Future<void> _validateRegistration(RegisterParams params) async {
    if (params.displayName.trim().isEmpty) {
      throw const AuthException(AuthErrorCode.displayNameRequired);
    }
    _validateEmail(params.email);
    _validatePassword(params.password);
    if (params.password != params.confirmPassword) {
      throw const AuthException(AuthErrorCode.passwordsDoNotMatch);
    }
    if (params.securityAnswer.trim().isEmpty) {
      throw const AuthException(AuthErrorCode.securityAnswerRequired);
    }
  }

  Future<void> _validatePasswordReset(ForgotPasswordParams params) async {
    _validateEmail(params.email);
    _validatePassword(params.newPassword);
    if (params.newPassword != params.confirmPassword) {
      throw const AuthException(AuthErrorCode.passwordsDoNotMatch);
    }
    if (params.securityAnswer.trim().isEmpty) {
      throw const AuthException(AuthErrorCode.securityAnswerRequired);
    }
  }

  void _validateEmail(String email) {
    final normalized = email.trim();
    if (normalized.isEmpty || !_emailRegex.hasMatch(normalized)) {
      throw const AuthException(AuthErrorCode.invalidEmail);
    }
  }

  void _validatePassword(String password) {
    if (password.length < 8) {
      throw const AuthException(AuthErrorCode.weakPassword);
    }
  }

  String _normalizeSecurityAnswer(String answer) {
    return answer.trim().toLowerCase();
  }

  AuthUser _mapUser(User user) {
    return AuthUser(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      createdAt: user.createdAt,
    );
  }

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
}
