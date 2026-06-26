part of 'forgot_password_bloc.dart';

final class ForgotPasswordState extends BaseState {
  const ForgotPasswordState({
    super.status = BaseStatus.initial,
    super.message,
    this.errorCode,
  });

  final AuthErrorCode? errorCode;

  ForgotPasswordState copyWith({
    BaseStatus? status,
    String? message,
    AuthErrorCode? errorCode,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [...super.props, errorCode];
}
