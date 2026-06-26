part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
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
