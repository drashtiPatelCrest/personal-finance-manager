import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/budget.dart';
import '../../../domain/entities/budget_error_code.dart';
import '../../../domain/entities/budget_params.dart';
import '../../../domain/usecases/budget_usecases.dart';
import '../../../../transactions/domain/entities/transaction.dart';
import '../../../../transactions/domain/entities/transaction_params.dart';
import '../../../../transactions/domain/usecases/transaction_usecases.dart';

part 'budget_list_event.dart';
part 'budget_list_state.dart';

@injectable
class BudgetListBloc extends Bloc<BudgetListEvent, BudgetListState> {
  BudgetListBloc(
    this._watchBudgetsUseCase,
    this._deleteBudgetUseCase,
    this._getBudgetUsageUseCase,
    this._watchTransactionsUseCase,
  ) : super(const BudgetListState()) {
    on<BudgetListStarted>(_onStarted);
    on<BudgetListSearchChanged>(_onSearchChanged);
    on<BudgetListDeleteRequested>(_onDeleteRequested);
    on<BudgetListUpdated>(_onUpdated);
    on<BudgetListTransactionsUpdated>(_onTransactionsUpdated);
    on<BudgetListFailed>(_onFailed);
  }

  final WatchBudgetsUseCase _watchBudgetsUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final GetBudgetUsageUseCase _getBudgetUsageUseCase;
  final WatchTransactionsUseCase _watchTransactionsUseCase;
  StreamSubscription<List<Budget>>? _subscription;
  StreamSubscription<List<Transaction>>? _transactionSubscription;

  Future<void> _onStarted(
    BudgetListStarted event,
    Emitter<BudgetListState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    await _subscription?.cancel();
    await _transactionSubscription?.cancel();
    try {
      final stream = await _watchBudgetsUseCase(
        WatchBudgetsParams(query: state.searchQuery),
      );

      _subscription = stream.listen(
        (budgets) => add(BudgetListUpdated(budgets)),
        onError: (_) => add(const BudgetListFailed(BudgetErrorCode.unknown)),
      );

      final transactionStream = await _watchTransactionsUseCase(
        const WatchTransactionsParams(),
      );
      _transactionSubscription = transactionStream.listen(
        (_) => add(const BudgetListTransactionsUpdated()),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: BudgetErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onSearchChanged(
    BudgetListSearchChanged event,
    Emitter<BudgetListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(const BudgetListStarted());
  }

  Future<void> _onDeleteRequested(
    BudgetListDeleteRequested event,
    Emitter<BudgetListState> emit,
  ) async {
    try {
      await _deleteBudgetUseCase(DeleteBudgetParams(id: event.budgetId));
      emit(state.copyWith(clearError: true));
    } on BudgetException catch (error) {
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: BudgetErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onUpdated(
    BudgetListUpdated event,
    Emitter<BudgetListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        budgets: event.budgets,
        clearError: true,
      ),
    );

    if (event.budgets.isEmpty) {
      emit(state.copyWith(usages: const {}));
      return;
    }

    try {
      final usages = await Future.wait(
        event.budgets.map(
          (budget) => _getBudgetUsageUseCase(
            GetBudgetUsageParams(id: budget.id),
          ),
        ),
      );
      final usageMap = {
        for (final usage in usages) usage.budget.id: usage,
      };
      emit(state.copyWith(usages: usageMap));
    } catch (_) {
      // Keep budget list visible even if usage refresh fails.
    }
  }

  Future<void> _onTransactionsUpdated(
    BudgetListTransactionsUpdated event,
    Emitter<BudgetListState> emit,
  ) async {
    if (state.budgets.isEmpty) {
      return;
    }

    try {
      final usages = await Future.wait(
        state.budgets.map(
          (budget) => _getBudgetUsageUseCase(
            GetBudgetUsageParams(id: budget.id),
          ),
        ),
      );
      final usageMap = {
        for (final usage in usages) usage.budget.id: usage,
      };
      emit(state.copyWith(usages: usageMap));
    } catch (_) {
      // Keep budget list visible even if usage refresh fails.
    }
  }

  void _onFailed(BudgetListFailed event, Emitter<BudgetListState> emit) {
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
    _transactionSubscription?.cancel();
    return super.close();
  }
}
