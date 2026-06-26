part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.session);

  final AuthenticatedSession session;

  @override
  List<Object?> get props => [session];
}

final class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}

final class AuthAccountDeleted extends AuthEvent {
  const AuthAccountDeleted();
}
