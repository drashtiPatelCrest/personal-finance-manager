import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._getAuthSessionUseCase,
    this._signOutUseCase,
  ) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthAccountDeleted>(_onAuthAccountDeleted);
  }

  final GetAuthSessionUseCase _getAuthSessionUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> initialize() async {
    add(const AuthCheckRequested());
    await stream.firstWhere((state) => state.status != AuthStatus.unknown);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final session = await _getAuthSessionUseCase(const NoParams());
      if (session == null) {
        emit(const AuthState(status: AuthStatus.unauthenticated));
        return;
      }

      emit(
        AuthState(
          status: AuthStatus.authenticated,
          session: session,
        ),
      );
    } catch (_) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    emit(
      AuthState(
        status: AuthStatus.authenticated,
        session: event.session,
      ),
    );
  }

  Future<void> _onAuthLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _signOutUseCase(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _onAuthAccountDeleted(
    AuthAccountDeleted event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
