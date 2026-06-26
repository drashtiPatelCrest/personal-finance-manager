import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/auth_error_code.dart';
import '../../../domain/entities/auth_params.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._registerUseCase) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  final RegisterUseCase _registerUseCase;

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    try {
      final session = await _registerUseCase(
        RegisterParams(
          displayName: event.displayName,
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword,
          securityAnswer: event.securityAnswer,
        ),
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
