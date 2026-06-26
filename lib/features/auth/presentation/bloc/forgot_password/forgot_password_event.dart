part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted({
    required this.email,
    required this.securityAnswer,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String email;
  final String securityAnswer;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object?> get props =>
      [email, securityAnswer, newPassword, confirmPassword];
}
