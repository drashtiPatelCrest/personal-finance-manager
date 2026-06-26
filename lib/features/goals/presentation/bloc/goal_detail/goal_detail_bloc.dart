import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/goal_error_code.dart';
import '../../../domain/entities/goal_params.dart';
import '../../../domain/entities/savings_goal.dart';
import '../../../domain/usecases/goal_usecases.dart';

part 'goal_detail_event.dart';
part 'goal_detail_state.dart';

@injectable
class GoalDetailBloc extends Bloc<GoalDetailEvent, GoalDetailState> {
  GoalDetailBloc(
    this._getGoalProgressUseCase,
    this._addContributionUseCase,
    this._deleteGoalUseCase,
    this._watchGoalsUseCase,
  ) : super(const GoalDetailState()) {
    on<GoalDetailLoadRequested>(_onLoadRequested);
    on<GoalDetailContributionSubmitted>(_onContributionSubmitted);
    on<GoalDetailDeleteRequested>(_onDeleteRequested);
    on<GoalDetailGoalsUpdated>(_onGoalsUpdated);
  }

  final GetGoalProgressUseCase _getGoalProgressUseCase;
  final AddContributionUseCase _addContributionUseCase;
  final DeleteGoalUseCase _deleteGoalUseCase;
  final WatchGoalsUseCase _watchGoalsUseCase;
  StreamSubscription<List<SavingsGoal>>? _subscription;
  String? _goalId;

  Future<void> _onLoadRequested(
    GoalDetailLoadRequested event,
    Emitter<GoalDetailState> emit,
  ) async {
    _goalId = event.goalId;
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    await _subscription?.cancel();
    try {
      final stream = await _watchGoalsUseCase(const WatchGoalsParams());
      _subscription = stream.listen(
        (_) => add(const GoalDetailGoalsUpdated()),
      );

      final progress = await _getGoalProgressUseCase(
        GetGoalProgressParams(id: event.goalId),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          progress: progress,
        ),
      );
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

  Future<void> _onGoalsUpdated(
    GoalDetailGoalsUpdated event,
    Emitter<GoalDetailState> emit,
  ) async {
    final goalId = _goalId;
    if (goalId == null) {
      return;
    }

    try {
      final progress = await _getGoalProgressUseCase(
        GetGoalProgressParams(id: goalId),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          progress: progress,
        ),
      );
    } catch (_) {
      // Keep existing progress visible if refresh fails.
    }
  }

  Future<void> _onContributionSubmitted(
    GoalDetailContributionSubmitted event,
    Emitter<GoalDetailState> emit,
  ) async {
    emit(state.copyWith(isContributing: true, clearError: true));
    try {
      await _addContributionUseCase(
        AddContributionParams(
          goalId: event.goalId,
          amount: event.amount,
          date: event.date,
        ),
      );
      final progress = await _getGoalProgressUseCase(
        GetGoalProgressParams(id: event.goalId),
      );
      emit(
        state.copyWith(
          isContributing: false,
          progress: progress,
          contributionAdded: true,
        ),
      );
      emit(state.copyWith(contributionAdded: false));
    } on GoalException catch (error) {
      emit(
        state.copyWith(
          isContributing: false,
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isContributing: false,
          errorCode: GoalErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    GoalDetailDeleteRequested event,
    Emitter<GoalDetailState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, clearError: true));
    try {
      await _deleteGoalUseCase(DeleteGoalParams(id: event.goalId));
      emit(state.copyWith(isDeleting: false, deleted: true));
    } on GoalException catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorCode: error.code,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorCode: GoalErrorCode.unknown,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
