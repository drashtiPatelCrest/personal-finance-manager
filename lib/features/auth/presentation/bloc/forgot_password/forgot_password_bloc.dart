import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/auth_error_code.dart';
import '../../../domain/entities/auth_params.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

@injectable
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._forgotPasswordUseCase)
      : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    try {
      await _forgotPasswordUseCase(
        ForgotPasswordParams(
          email: event.email,
          securityAnswer: event.securityAnswer,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        ),
      );
      emit(state.copyWith(status: BaseStatus.success));
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
