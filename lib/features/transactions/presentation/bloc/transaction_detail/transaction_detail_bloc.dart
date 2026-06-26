import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_error_code.dart';
import '../../../domain/entities/transaction_params.dart';
import '../../../domain/usecases/transaction_usecases.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

@injectable
class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionDetailBloc(
    this._getTransactionByIdUseCase,
    this._deleteTransactionUseCase,
  ) : super(const TransactionDetailState()) {
    on<TransactionDetailLoadRequested>(_onLoadRequested);
    on<TransactionDetailDeleteRequested>(_onDeleteRequested);
  }

  final GetTransactionByIdUseCase _getTransactionByIdUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  Future<void> _onLoadRequested(
    TransactionDetailLoadRequested event,
    Emitter<TransactionDetailState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    try {
      final transaction = await _getTransactionByIdUseCase(
        GetTransactionByIdParams(id: event.transactionId),
      );
      if (transaction == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: TransactionErrorCode.transactionNotFound,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          transaction: transaction,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: TransactionErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    TransactionDetailDeleteRequested event,
    Emitter<TransactionDetailState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, clearError: true));
    try {
      await _deleteTransactionUseCase(
        DeleteTransactionParams(id: event.transactionId),
      );
      emit(state.copyWith(isDeleting: false, deleted: true));
    } on TransactionException catch (error) {
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
          errorCode: TransactionErrorCode.unknown,
        ),
      );
    }
  }
}
