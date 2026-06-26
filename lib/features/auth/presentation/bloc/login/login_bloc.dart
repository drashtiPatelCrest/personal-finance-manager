import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/auth_error_code.dart';
import '../../../domain/entities/auth_params.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUseCase) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    try {
      final session = await _loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          session: session,
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: error.code,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: AuthErrorCode.unknown,
        ),
      );
    }
  }
}
