import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../budgets/domain/entities/budget.dart';
import '../../../../budgets/domain/entities/budget_params.dart';
import '../../../../budgets/domain/usecases/budget_usecases.dart';
import '../../../../goals/domain/entities/savings_goal.dart';
import '../../../../goals/domain/entities/goal_params.dart';
import '../../../../goals/domain/usecases/goal_usecases.dart';
import '../../../../transactions/domain/entities/transaction.dart';
import '../../../../transactions/domain/entities/transaction_params.dart';
import '../../../../transactions/domain/usecases/transaction_usecases.dart';
import '../../../domain/entities/dashboard_error_code.dart';
import '../../../domain/entities/dashboard_params.dart';
import '../../../domain/entities/dashboard_snapshot.dart';
import '../../../domain/usecases/dashboard_usecases.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
    this._getDashboardDataUseCase,
    this._watchTransactionsUseCase,
    this._watchBudgetsUseCase,
    this._watchGoalsUseCase,
  ) : super(DashboardState.initial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardDateRangeChanged>(_onDateRangeChanged);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<DashboardDataUpdated>(_onDataUpdated);
    on<DashboardFailed>(_onFailed);
  }

  final GetDashboardDataUseCase _getDashboardDataUseCase;
  final WatchTransactionsUseCase _watchTransactionsUseCase;
  final WatchBudgetsUseCase _watchBudgetsUseCase;
  final WatchGoalsUseCase _watchGoalsUseCase;
  StreamSubscription<List<Transaction>>? _transactionSubscription;
  StreamSubscription<List<Budget>>? _budgetSubscription;
  StreamSubscription<List<SavingsGoal>>? _goalSubscription;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    await _subscribe();
    await _loadDashboard(emit);
  }

  Future<void> _onDateRangeChanged(
    DashboardDateRangeChanged event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        dateRangePreset: event.preset,
        status: BaseStatus.loading,
        clearError: true,
        clearSnapshot: true,
      ),
    );
    await _loadDashboard(emit);
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    await _loadDashboard(emit);
  }

  Future<void> _onDataUpdated(
    DashboardDataUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboard(emit, showLoading: false);
  }

  void _onFailed(DashboardFailed event, Emitter<DashboardState> emit) {
    if (state.snapshot != null) {
      return;
    }

    emit(
      state.copyWith(
        status: BaseStatus.failure,
        errorCode: event.errorCode,
        errorNonce: state.errorNonce + 1,
      ),
    );
  }

  Future<void> _subscribe() async {
    await _transactionSubscription?.cancel();
    await _budgetSubscription?.cancel();
    await _goalSubscription?.cancel();

    try {
      final transactionStream = await _watchTransactionsUseCase(
        const WatchTransactionsParams(),
      );
      _transactionSubscription = transactionStream.listen(
        (_) => add(const DashboardDataUpdated()),
        onError: (_) => add(const DashboardFailed(DashboardErrorCode.unknown)),
      );

      final budgetStream = await _watchBudgetsUseCase(
        const WatchBudgetsParams(),
      );
      _budgetSubscription = budgetStream.listen(
        (_) => add(const DashboardDataUpdated()),
        onError: (_) => add(const DashboardFailed(DashboardErrorCode.unknown)),
      );

      final goalStream = await _watchGoalsUseCase(const WatchGoalsParams());
      _goalSubscription = goalStream.listen(
        (_) => add(const DashboardDataUpdated()),
        onError: (_) => add(const DashboardFailed(DashboardErrorCode.unknown)),
      );
    } catch (_) {
      add(const DashboardFailed(DashboardErrorCode.unknown));
    }
  }

  Future<void> _loadDashboard(
    Emitter<DashboardState> emit, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    }

    try {
      final range = state.dateRangePreset.resolve();
      final snapshot = await _getDashboardDataUseCase(
        GetDashboardParams(
          startDate: range.startDate,
          endDate: range.endDate,
        ),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          snapshot: snapshot,
          clearError: true,
        ),
      );
    } on DashboardException catch (error) {
      if (!showLoading && state.snapshot != null) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      if (!showLoading && state.snapshot != null) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: DashboardErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    _budgetSubscription?.cancel();
    _goalSubscription?.cancel();
    return super.close();
  }
}
