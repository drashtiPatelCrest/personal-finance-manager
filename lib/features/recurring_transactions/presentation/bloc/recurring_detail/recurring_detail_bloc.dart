import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/recurring_transaction.dart';
import '../../../domain/entities/recurring_transaction_error_code.dart';
import '../../../domain/entities/recurring_transaction_params.dart';
import '../../../domain/usecases/recurring_transaction_usecases.dart';

part 'recurring_detail_event.dart';
part 'recurring_detail_state.dart';

@injectable
class RecurringDetailBloc
    extends Bloc<RecurringDetailEvent, RecurringDetailState> {
  RecurringDetailBloc(
    this._getRecurringTransactionByIdUseCase,
    this._deleteRecurringTransactionUseCase,
    this._pauseRecurringTransactionUseCase,
    this._resumeRecurringTransactionUseCase,
    this._watchRecurringTransactionsUseCase,
  ) : super(const RecurringDetailState()) {
    on<RecurringDetailLoadRequested>(_onLoadRequested);
    on<RecurringDetailDeleteRequested>(_onDeleteRequested);
    on<RecurringDetailPauseRequested>(_onPauseRequested);
    on<RecurringDetailResumeRequested>(_onResumeRequested);
    on<RecurringDetailUpdated>(_onUpdated);
  }

  final GetRecurringTransactionByIdUseCase _getRecurringTransactionByIdUseCase;
  final DeleteRecurringTransactionUseCase _deleteRecurringTransactionUseCase;
  final PauseRecurringTransactionUseCase _pauseRecurringTransactionUseCase;
  final ResumeRecurringTransactionUseCase _resumeRecurringTransactionUseCase;
  final WatchRecurringTransactionsUseCase _watchRecurringTransactionsUseCase;
  StreamSubscription<List<RecurringTransaction>>? _subscription;
  String? _recurringId;

  Future<void> _onLoadRequested(
    RecurringDetailLoadRequested event,
    Emitter<RecurringDetailState> emit,
  ) async {
    _recurringId = event.recurringId;
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    await _subscription?.cancel();
    try {
      final stream = await _watchRecurringTransactionsUseCase(
        const WatchRecurringTransactionsParams(),
      );
      _subscription = stream.listen(
        (_) => add(const RecurringDetailUpdated()),
      );

      final recurring = await _getRecurringTransactionByIdUseCase(
        GetRecurringTransactionByIdParams(id: event.recurringId),
      );
      if (recurring == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: RecurringTransactionErrorCode.notFound,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          recurring: recurring,
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

  Future<void> _onUpdated(
    RecurringDetailUpdated event,
    Emitter<RecurringDetailState> emit,
  ) async {
    final recurringId = _recurringId;
    if (recurringId == null) {
      return;
    }

    try {
      final recurring = await _getRecurringTransactionByIdUseCase(
        GetRecurringTransactionByIdParams(id: recurringId),
      );
      if (recurring == null) {
        return;
      }
      emit(
        state.copyWith(
          status: BaseStatus.success,
          recurring: recurring,
        ),
      );
    } catch (_) {
      // Keep existing data visible if refresh fails.
    }
  }

  Future<void> _onDeleteRequested(
    RecurringDetailDeleteRequested event,
    Emitter<RecurringDetailState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, clearError: true));
    try {
      await _deleteRecurringTransactionUseCase(
        DeleteRecurringTransactionParams(id: event.recurringId),
      );
      emit(state.copyWith(isDeleting: false, deleted: true));
    } on RecurringTransactionException catch (error) {
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
          errorCode: RecurringTransactionErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onPauseRequested(
    RecurringDetailPauseRequested event,
    Emitter<RecurringDetailState> emit,
  ) async {
    emit(state.copyWith(isUpdatingStatus: true, clearError: true));
    try {
      final recurring = await _pauseRecurringTransactionUseCase(
        RecurringTransactionIdParams(id: event.recurringId),
      );
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          recurring: recurring,
          statusChanged: true,
        ),
      );
      emit(state.copyWith(statusChanged: false));
    } on RecurringTransactionException catch (error) {
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          errorCode: RecurringTransactionErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onResumeRequested(
    RecurringDetailResumeRequested event,
    Emitter<RecurringDetailState> emit,
  ) async {
    emit(state.copyWith(isUpdatingStatus: true, clearError: true));
    try {
      final recurring = await _resumeRecurringTransactionUseCase(
        RecurringTransactionIdParams(id: event.recurringId),
      );
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          recurring: recurring,
          statusChanged: true,
        ),
      );
      emit(state.copyWith(statusChanged: false));
    } on RecurringTransactionException catch (error) {
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isUpdatingStatus: false,
          errorCode: RecurringTransactionErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
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
