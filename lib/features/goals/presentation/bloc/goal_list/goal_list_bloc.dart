import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/goal_error_code.dart';
import '../../../domain/entities/goal_params.dart';
import '../../../domain/entities/savings_goal.dart';
import '../../../domain/usecases/goal_usecases.dart';

part 'goal_list_event.dart';
part 'goal_list_state.dart';

@injectable
class GoalListBloc extends Bloc<GoalListEvent, GoalListState> {
  GoalListBloc(
    this._watchGoalsUseCase,
    this._deleteGoalUseCase,
    this._getGoalProgressUseCase,
  ) : super(const GoalListState()) {
    on<GoalListStarted>(_onStarted);
    on<GoalListSearchChanged>(_onSearchChanged);
    on<GoalListStatusFilterChanged>(_onStatusFilterChanged);
    on<GoalListDeleteRequested>(_onDeleteRequested);
    on<GoalListUpdated>(_onUpdated);
    on<GoalListFailed>(_onFailed);
  }

  final WatchGoalsUseCase _watchGoalsUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final GetGoalProgressUseCase _getGoalProgressUseCase;
  StreamSubscription<List<SavingsGoal>>? _subscription;

  Future<void> _onStarted(
    GoalListStarted event,
    Emitter<GoalListState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    await _subscription?.cancel();
    try {
      final stream = await _watchGoalsUseCase(
        WatchGoalsParams(
          status: state.selectedStatus,
          query: state.searchQuery,
        ),
      );

      _subscription = stream.listen(
        (goals) => add(GoalListUpdated(goals)),
        onError: (_) => add(const GoalListFailed(GoalErrorCode.unknown)),
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

  Future<void> _onSearchChanged(
    GoalListSearchChanged event,
    Emitter<GoalListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(const GoalListStarted());
  }

  Future<void> _onStatusFilterChanged(
    GoalListStatusFilterChanged event,
    Emitter<GoalListState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedStatus: event.status,
        clearSelectedStatus: event.status == null,
      ),
    );
    add(const GoalListStarted());
  }

  Future<void> _onDeleteRequested(
    GoalListDeleteRequested event,
    Emitter<GoalListState> emit,
  ) async {
    try {
      await _deleteGoalUseCase(DeleteGoalParams(id: event.goalId));
      emit(state.copyWith(clearError: true));
    } on GoalException catch (error) {
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: GoalErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onUpdated(
    GoalListUpdated event,
    Emitter<GoalListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        goals: event.goals,
        clearError: true,
      ),
    );

    if (event.goals.isEmpty) {
      emit(state.copyWith(progressMap: const {}));
      return;
    }

    try {
      final progressList = await Future.wait(
        event.goals.map(
          (goal) => _getGoalProgressUseCase(GetGoalProgressParams(id: goal.id)),
        ),
      );
      emit(
        state.copyWith(
          progressMap: {
            for (final progress in progressList) progress.goal.id: progress,
          },
        ),
      );
    } catch (_) {
      // Keep goal list visible even if progress refresh fails.
    }
  }

  void _onFailed(GoalListFailed event, Emitter<GoalListState> emit) {
    emit(
      state.copyWith(
        status: BaseStatus.failure,
        errorCode: event.errorCode,
        errorNonce: state.errorNonce + 1,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
