part of 'login_bloc.dart';

final class LoginState extends BaseState {
  const LoginState({
    super.status = BaseStatus.initial,
    super.message,
    this.errorCode,
    this.session,
  });

  final AuthErrorCode? errorCode;
  final AuthenticatedSession? session;

  LoginState copyWith({
    BaseStatus? status,
    String? message,
    AuthErrorCode? errorCode,
    AuthenticatedSession? session,
    bool clearError = false,
    bool clearSession = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      session: clearSession ? null : session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [...super.props, errorCode, session];
}
