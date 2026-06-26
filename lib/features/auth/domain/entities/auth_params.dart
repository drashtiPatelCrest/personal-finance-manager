import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.displayName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.securityAnswer,
  });

  final String displayName;
  final String email;
  final String password;
  final String confirmPassword;
  final String securityAnswer;

  @override
  List<Object?> get props =>
      [displayName, email, password, confirmPassword, securityAnswer];
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({
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
