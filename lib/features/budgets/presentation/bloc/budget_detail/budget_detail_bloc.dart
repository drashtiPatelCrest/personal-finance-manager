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

part 'budget_detail_event.dart';
part 'budget_detail_state.dart';

@injectable
class BudgetDetailBloc extends Bloc<BudgetDetailEvent, BudgetDetailState> {
  BudgetDetailBloc(
    this._getBudgetUsageUseCase,
    this._deleteBudgetUseCase,
    this._watchTransactionsUseCase,
  ) : super(const BudgetDetailState()) {
    on<BudgetDetailLoadRequested>(_onLoadRequested);
    on<BudgetDetailDeleteRequested>(_onDeleteRequested);
    on<BudgetDetailTransactionsUpdated>(_onTransactionsUpdated);
  }

  final GetBudgetUsageUseCase _getBudgetUsageUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final WatchTransactionsUseCase _watchTransactionsUseCase;
  StreamSubscription<List<Transaction>>? _transactionSubscription;
  String? _budgetId;

  Future<void> _onLoadRequested(
    BudgetDetailLoadRequested event,
    Emitter<BudgetDetailState> emit,
  ) async {
    _budgetId = event.budgetId;
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    await _transactionSubscription?.cancel();
    try {
      final transactionStream = await _watchTransactionsUseCase(
        const WatchTransactionsParams(),
      );
      _transactionSubscription = transactionStream.listen(
        (_) => add(const BudgetDetailTransactionsUpdated()),
      );

      final usage = await _getBudgetUsageUseCase(
        GetBudgetUsageParams(id: event.budgetId),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          usage: usage,
        ),
      );
    } on BudgetException catch (error) {
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
          errorCode: BudgetErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onTransactionsUpdated(
    BudgetDetailTransactionsUpdated event,
    Emitter<BudgetDetailState> emit,
  ) async {
    final budgetId = _budgetId;
    if (budgetId == null) {
      return;
    }

    try {
      final usage = await _getBudgetUsageUseCase(
        GetBudgetUsageParams(id: budgetId),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          usage: usage,
        ),
      );
    } catch (_) {
      // Keep existing usage visible if refresh fails.
    }
  }

  Future<void> _onDeleteRequested(
    BudgetDetailDeleteRequested event,
    Emitter<BudgetDetailState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, clearError: true));
    try {
      await _deleteBudgetUseCase(DeleteBudgetParams(id: event.budgetId));
      emit(state.copyWith(isDeleting: false, deleted: true));
    } on BudgetException catch (error) {
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
          errorCode: BudgetErrorCode.unknown,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}
