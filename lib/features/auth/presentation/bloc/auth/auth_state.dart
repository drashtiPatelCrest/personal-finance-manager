part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.session,
  });

  final AuthStatus status;
  final AuthenticatedSession? session;

  @override
  List<Object?> get props => [status, session];
}
