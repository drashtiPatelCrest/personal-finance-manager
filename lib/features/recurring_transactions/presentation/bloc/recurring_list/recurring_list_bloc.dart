import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/recurring_transaction.dart';
import '../../../domain/entities/recurring_transaction_error_code.dart';
import '../../../domain/entities/recurring_transaction_params.dart';
import '../../../domain/usecases/recurring_transaction_usecases.dart';

part 'recurring_list_event.dart';
part 'recurring_list_state.dart';

@injectable
class RecurringListBloc extends Bloc<RecurringListEvent, RecurringListState> {
  RecurringListBloc(
    this._watchRecurringTransactionsUseCase,
    this._deleteRecurringTransactionUseCase,
    this._pauseRecurringTransactionUseCase,
    this._resumeRecurringTransactionUseCase,
    this._processDueRecurringTransactionsUseCase,
  ) : super(const RecurringListState()) {
    on<RecurringListStarted>(_onStarted);
    on<RecurringListSearchChanged>(_onSearchChanged);
    on<RecurringListStatusFilterChanged>(_onStatusFilterChanged);
    on<RecurringListDeleteRequested>(_onDeleteRequested);
    on<RecurringListPauseRequested>(_onPauseRequested);
    on<RecurringListResumeRequested>(_onResumeRequested);
    on<RecurringListUpdated>(_onUpdated);
    on<RecurringListFailed>(_onFailed);
  }

  final WatchRecurringTransactionsUseCase _watchRecurringTransactionsUseCase;
  final DeleteRecurringTransactionUseCase _deleteRecurringTransactionUseCase;
  final PauseRecurringTransactionUseCase _pauseRecurringTransactionUseCase;
  final ResumeRecurringTransactionUseCase _resumeRecurringTransactionUseCase;
  final ProcessDueRecurringTransactionsUseCase
      _processDueRecurringTransactionsUseCase;
  StreamSubscription<List<RecurringTransaction>>? _subscription;

  Future<void> _onStarted(
    RecurringListStarted event,
    Emitter<RecurringListState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      await _processDueRecurringTransactionsUseCase(const NoParams());
    } catch (_) {
      // Keep the list usable if due processing fails.
    }

    await _subscription?.cancel();
    try {
      final stream = await _watchRecurringTransactionsUseCase(
        WatchRecurringTransactionsParams(
          isPaused: state.selectedPaused,
          query: state.searchQuery,
        ),
      );

      _subscription = stream.listen(
        (items) => add(RecurringListUpdated(items)),
        onError: (_) => add(
          const RecurringListFailed(RecurringTransactionErrorCode.unknown),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: RecurringTransactionErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onSearchChanged(
    RecurringListSearchChanged event,
    Emitter<RecurringListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(const RecurringListStarted());
  }

  Future<void> _onStatusFilterChanged(
    RecurringListStatusFilterChanged event,
    Emitter<RecurringListState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedPaused: event.isPaused,
        clearSelectedPaused: event.isPaused == null,
      ),
    );
    add(const RecurringListStarted());
  }

  Future<void> _onDeleteRequested(
    RecurringListDeleteRequested event,
    Emitter<RecurringListState> emit,
  ) async {
    try {
      await _deleteRecurringTransactionUseCase(
        DeleteRecurringTransactionParams(id: event.recurringId),
      );
      emit(state.copyWith(clearError: true));
    } on RecurringTransactionException catch (error) {
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: RecurringTransactionErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onPauseRequested(
    RecurringListPauseRequested event,
    Emitter<RecurringListState> emit,
  ) async {
    try {
      await _pauseRecurringTransactionUseCase(
        RecurringTransactionIdParams(id: event.recurringId),
      );
      emit(state.copyWith(clearError: true));
    } on RecurringTransactionException catch (error) {
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: RecurringTransactionErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onResumeRequested(
    RecurringListResumeRequested event,
    Emitter<RecurringListState> emit,
  ) async {
    try {
      await _resumeRecurringTransactionUseCase(
        RecurringTransactionIdParams(id: event.recurringId),
      );
      emit(state.copyWith(clearError: true));
    } on RecurringTransactionException catch (error) {
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: RecurringTransactionErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  void _onUpdated(
    RecurringListUpdated event,
    Emitter<RecurringListState> emit,
  ) {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        items: event.items,
        clearError: true,
      ),
    );
  }

  void _onFailed(RecurringListFailed event, Emitter<RecurringListState> emit) {
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
