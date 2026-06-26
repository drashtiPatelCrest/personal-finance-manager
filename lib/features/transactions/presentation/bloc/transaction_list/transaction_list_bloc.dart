import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../categories/domain/entities/category.dart';
import '../../../../categories/domain/entities/category_params.dart';
import '../../../../categories/domain/usecases/category_usecases.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/entities/transaction_error_code.dart';
import '../../../domain/entities/transaction_params.dart';
import '../../../domain/usecases/transaction_usecases.dart';

part 'transaction_list_event.dart';
part 'transaction_list_state.dart';

@injectable
class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  TransactionListBloc(
    this._watchTransactionsUseCase,
    this._deleteTransactionUseCase,
    this._getTransactionSummaryUseCase,
    this._getCategoriesUseCase,
  ) : super(const TransactionListState()) {
    on<TransactionListStarted>(_onStarted);
    on<TransactionListSearchChanged>(_onSearchChanged);
    on<TransactionListTypeFilterChanged>(_onTypeFilterChanged);
    on<TransactionListCategoryFilterChanged>(_onCategoryFilterChanged);
    on<TransactionListDateRangeChanged>(_onDateRangeChanged);
    on<TransactionListDateRangeCleared>(_onDateRangeCleared);
    on<TransactionListDeleteRequested>(_onDeleteRequested);
    on<TransactionListUpdated>(_onUpdated);
    on<TransactionListFailed>(_onFailed);
  }

  final WatchTransactionsUseCase _watchTransactionsUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final GetTransactionSummaryUseCase _getTransactionSummaryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  StreamSubscription<List<Transaction>>? _subscription;

  TransactionFilter get _currentFilter => TransactionFilter(
        type: state.selectedType,
        categoryId: state.selectedCategoryId,
        startDate: state.startDate,
        endDate: state.endDate,
        query: state.searchQuery,
      );

  Future<void> _onStarted(
    TransactionListStarted event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      final categories = await _getCategoriesUseCase(const GetCategoriesParams());
      emit(state.copyWith(categories: categories));
      await _loadSummaries(emit);
      await _subscribe(emit);
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: TransactionErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _subscribe(Emitter<TransactionListState> emit) async {
    await _subscription?.cancel();
    try {
      final stream = await _watchTransactionsUseCase(
        WatchTransactionsParams(filter: _currentFilter),
      );

      _subscription = stream.listen(
        (transactions) => add(TransactionListUpdated(transactions)),
        onError: (_) =>
            add(const TransactionListFailed(TransactionErrorCode.unknown)),
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

  Future<void> _loadSummaries(Emitter<TransactionListState> emit) async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final today = DateTime(now.year, now.month, now.day);

    final results = await Future.wait([
      _getTransactionSummaryUseCase(
        GetTransactionSummaryParams(startDate: today, endDate: today),
      ),
      _getTransactionSummaryUseCase(
        GetTransactionSummaryParams(
          startDate: monthStart,
          endDate: monthEnd,
        ),
      ),
    ]);

    emit(
      state.copyWith(
        dailySummary: results[0],
        monthlySummary: results[1],
      ),
    );
  }

  Future<void> _onSearchChanged(
    TransactionListSearchChanged event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    await _subscribe(emit);
  }

  Future<void> _onTypeFilterChanged(
    TransactionListTypeFilterChanged event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedType: event.type,
        clearSelectedType: event.type == null,
        clearSelectedCategoryId: true,
      ),
    );
    await _subscribe(emit);
  }

  Future<void> _onCategoryFilterChanged(
    TransactionListCategoryFilterChanged event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedCategoryId: event.categoryId,
        clearSelectedCategoryId: event.categoryId == null,
      ),
    );
    await _subscribe(emit);
  }

  Future<void> _onDateRangeChanged(
    TransactionListDateRangeChanged event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(
      state.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    await _subscribe(emit);
  }

  Future<void> _onDateRangeCleared(
    TransactionListDateRangeCleared event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(
      state.copyWith(
        clearStartDate: true,
        clearEndDate: true,
      ),
    );
    await _subscribe(emit);
  }

  Future<void> _onDeleteRequested(
    TransactionListDeleteRequested event,
    Emitter<TransactionListState> emit,
  ) async {
    try {
      await _deleteTransactionUseCase(
        DeleteTransactionParams(id: event.transactionId),
      );
      await _loadSummaries(emit);
      emit(state.copyWith(clearError: true));
    } on TransactionException catch (error) {
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorCode: TransactionErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  Future<void> _onUpdated(
    TransactionListUpdated event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        transactions: event.transactions,
        clearError: true,
      ),
    );
    await _loadSummaries(emit);
  }

  void _onFailed(
    TransactionListFailed event,
    Emitter<TransactionListState> emit,
  ) {
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
