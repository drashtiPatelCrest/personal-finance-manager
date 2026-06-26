import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/goal_error_code.dart';
import '../../../domain/entities/goal_params.dart';
import '../../../domain/usecases/goal_usecases.dart';

part 'goal_form_event.dart';
part 'goal_form_state.dart';

@injectable
class GoalFormBloc extends Bloc<GoalFormEvent, GoalFormState> {
  GoalFormBloc(
    this._getGoalByIdUseCase,
    this._createGoalUseCase,
    this._updateGoalUseCase,
  ) : super(GoalFormState.initial()) {
    on<GoalFormLoadRequested>(_onLoadRequested);
    on<GoalFormSubmitted>(_onSubmitted);
    on<GoalFormDeadlineChanged>(_onDeadlineChanged);
  }

  final GetGoalByIdUseCase _getGoalByIdUseCase;
  final CreateGoalUseCase _createGoalUseCase;
  final UpdateGoalUseCase _updateGoalUseCase;

  Future<void> _onLoadRequested(
    GoalFormLoadRequested event,
    Emitter<GoalFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    if (event.goalId == null) {
      emit(
        GoalFormState.initial(
          deadline: DateTime.now().add(const Duration(days: 90)),
        ).copyWith(status: BaseStatus.success),
      );
      return;
    }

    try {
      final goal = await _getGoalByIdUseCase(
        GetGoalByIdParams(id: event.goalId!),
      );
      if (goal == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: GoalErrorCode.goalNotFound,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          goalId: goal.id,
          initialName: goal.name,
          initialTargetAmount: goal.targetAmount,
          deadline: goal.deadline,
          isEditing: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: GoalErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    GoalFormSubmitted event,
    Emitter<GoalFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      final deadline = state.deadline ?? DateTime.now();

      if (state.isEditing && state.goalId != null) {
        await _updateGoalUseCase(
          UpdateGoalParams(
            id: state.goalId!,
            name: event.name,
            targetAmount: event.targetAmount,
            deadline: deadline,
          ),
        );
      } else {
        await _createGoalUseCase(
          CreateGoalParams(
            name: event.name,
            targetAmount: event.targetAmount,
            deadline: deadline,
          ),
        );
      }

      emit(state.copyWith(status: BaseStatus.success, saved: true));
    } on GoalException catch (error) {
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
          errorCode: GoalErrorCode.unknown,
        ),
      );
    }
  }

  void _onDeadlineChanged(
    GoalFormDeadlineChanged event,
    Emitter<GoalFormState> emit,
  ) {
    emit(state.copyWith(deadline: event.deadline));
  }
}
