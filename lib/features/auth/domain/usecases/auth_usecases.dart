import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/auth_params.dart';
import '../entities/auth_session.dart';
import '../entities/auth_error_code.dart';
import '../repository/auth_repository.dart';
import '../../../settings/domain/repository/settings_repository.dart';

@injectable
class GetAuthSessionUseCase
    implements UseCase<AuthenticatedSession?, NoParams> {
  GetAuthSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthenticatedSession?> call(NoParams params) {
    return _repository.getCurrentSession();
  }
}

@injectable
class LoginUseCase implements UseCase<AuthenticatedSession, LoginParams> {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthenticatedSession> call(LoginParams params) {
    return _repository.login(params);
  }
}

@injectable
class RegisterUseCase implements UseCase<AuthenticatedSession, RegisterParams> {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthenticatedSession> call(RegisterParams params) {
    return _repository.register(params);
  }
}

@injectable
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(ForgotPasswordParams params) {
    return _repository.resetPassword(params);
  }
}

@injectable
class SignOutUseCase implements UseCase<void, NoParams> {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) {
    return _repository.signOut();
  }
}

@injectable
class HasRegisteredUsersUseCase implements UseCase<bool, NoParams> {
  HasRegisteredUsersUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<bool> call(NoParams params) {
    return _repository.hasRegisteredUsers();
  }
}

class DeleteAccountParams {
  const DeleteAccountParams({required this.userId});

  final int userId;
}

@injectable
class DeleteAccountUseCase implements UseCase<void, DeleteAccountParams> {
  DeleteAccountUseCase(this._authRepository, this._settingsRepository);

  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;

  @override
  Future<void> call(DeleteAccountParams params) async {
    try {
      await _authRepository.deleteAccount(userId: params.userId);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(AuthErrorCode.unknown);
    }

    try {
      await _settingsRepository.clearPreferences();
    } catch (_) {
      // Account data is already removed; do not block sign-out flow.
    }
  }
}
