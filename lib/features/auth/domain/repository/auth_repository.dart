import '../entities/auth_params.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthenticatedSession?> getCurrentSession();

  Future<AuthenticatedSession> login(LoginParams params);

  Future<AuthenticatedSession> register(RegisterParams params);

  Future<void> resetPassword(ForgotPasswordParams params);

  Future<bool> hasRegisteredUsers();

  Future<void> signOut();

  Future<void> deleteAccount({required int userId});
}
