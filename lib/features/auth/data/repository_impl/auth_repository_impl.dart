import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_params.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthenticatedSession?> getCurrentSession() {
    return _localDataSource.getCurrentSession();
  }

  @override
  Future<AuthenticatedSession> login(LoginParams params) {
    return _localDataSource.login(params);
  }

  @override
  Future<AuthenticatedSession> register(RegisterParams params) {
    return _localDataSource.register(params);
  }

  @override
  Future<void> resetPassword(ForgotPasswordParams params) {
    return _localDataSource.resetPassword(params);
  }

  @override
  Future<bool> hasRegisteredUsers() {
    return _localDataSource.hasRegisteredUsers();
  }

  @override
  Future<void> signOut() {
    return _localDataSource.clearSession();
  }

  @override
  Future<void> deleteAccount({required int userId}) {
    return _localDataSource.deleteAccount(userId: userId);
  }
}
