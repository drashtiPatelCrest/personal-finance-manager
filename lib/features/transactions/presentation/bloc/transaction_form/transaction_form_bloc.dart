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

part 'transaction_form_event.dart';
part 'transaction_form_state.dart';

@injectable
class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  TransactionFormBloc(
    this._getTransactionByIdUseCase,
    this._createTransactionUseCase,
    this._updateTransactionUseCase,
    this._getCategoriesUseCase,
  ) : super(TransactionFormState.initial()) {
    on<TransactionFormLoadRequested>(_onLoadRequested);
    on<TransactionFormSubmitted>(_onSubmitted);
    on<TransactionFormTypeChanged>(_onTypeChanged);
    on<TransactionFormCategoryChanged>(_onCategoryChanged);
    on<TransactionFormDateChanged>(_onDateChanged);
  }

  final GetTransactionByIdUseCase _getTransactionByIdUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadRequested(
    TransactionFormLoadRequested event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      final type = event.initialType ?? TransactionType.expense;
      final categories = await _getCategoriesUseCase(
        GetCategoriesParams(
          type: type == TransactionType.income
              ? CategoryType.income
              : CategoryType.expense,
        ),
      );

      if (event.transactionId == null) {
        emit(
          TransactionFormState.initial(
            type: type,
            categories: categories,
            selectedCategoryId: categories.isNotEmpty ? categories.first.id : null,
            date: DateTime.now(),
          ).copyWith(status: BaseStatus.success),
        );
        return;
      }

      final transaction = await _getTransactionByIdUseCase(
        GetTransactionByIdParams(id: event.transactionId!),
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

      final editCategories = await _getCategoriesUseCase(
        GetCategoriesParams(
          type: transaction.type == TransactionType.income
              ? CategoryType.income
              : CategoryType.expense,
        ),
      );

      emit(
        state.copyWith(
          status: BaseStatus.success,
          transactionId: transaction.id,
          type: transaction.type,
          categories: editCategories,
          selectedCategoryId: transaction.category.id,
          initialAmount: transaction.amount,
          initialNote: transaction.note,
          date: transaction.date,
          isEditing: true,
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

  Future<void> _onSubmitted(
    TransactionFormSubmitted event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      if (state.selectedCategoryId == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: TransactionErrorCode.categoryRequired,
          ),
        );
        return;
      }

      final date = state.date ?? DateTime.now();

      if (state.isEditing && state.transactionId != null) {
        await _updateTransactionUseCase(
          UpdateTransactionParams(
            id: state.transactionId!,
            type: state.type,
            amount: event.amount,
            categoryId: state.selectedCategoryId!,
            date: date,
            note: event.note,
          ),
        );
      } else {
        await _createTransactionUseCase(
          CreateTransactionParams(
            type: state.type,
            amount: event.amount,
            categoryId: state.selectedCategoryId!,
            date: date,
            note: event.note,
          ),
        );
      }

      emit(state.copyWith(status: BaseStatus.success, saved: true));
    } on TransactionException catch (error) {
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
          errorCode: TransactionErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onTypeChanged(
    TransactionFormTypeChanged event,
    Emitter<TransactionFormState> emit,
  ) async {
    if (state.isEditing) {
      return;
    }

    emit(state.copyWith(status: BaseStatus.loading));
    try {
      final categories = await _getCategoriesUseCase(
        GetCategoriesParams(
          type: event.type == TransactionType.income
              ? CategoryType.income
              : CategoryType.expense,
        ),
      );
      emit(
        state.copyWith(
          status: BaseStatus.success,
          type: event.type,
          categories: categories,
          selectedCategoryId:
              categories.isNotEmpty ? categories.first.id : null,
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

  void _onCategoryChanged(
    TransactionFormCategoryChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }

  void _onDateChanged(
    TransactionFormDateChanged event,
    Emitter<TransactionFormState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }
}
