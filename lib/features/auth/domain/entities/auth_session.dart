import 'package:equatable/equatable.dart';

import 'auth_user.dart';

class AuthenticatedSession extends Equatable {
  const AuthenticatedSession({required this.user});

  final AuthUser user;

  int get userId => user.id;

  String get email => user.email;

  String get displayName => user.displayName;

  @override
  List<Object?> get props => [user];
}
