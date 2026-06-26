import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../categories/domain/entities/category.dart';
import '../../../../categories/domain/entities/category_params.dart';
import '../../../../categories/domain/usecases/category_usecases.dart';
import '../../../domain/entities/recurring_transaction.dart';
import '../../../domain/entities/recurring_transaction_error_code.dart';
import '../../../domain/entities/recurring_transaction_params.dart';
import '../../../domain/usecases/recurring_transaction_usecases.dart';
import '../../../../transactions/domain/entities/transaction.dart';

part 'recurring_form_event.dart';
part 'recurring_form_state.dart';

@injectable
class RecurringFormBloc extends Bloc<RecurringFormEvent, RecurringFormState> {
  RecurringFormBloc(
    this._getRecurringTransactionByIdUseCase,
    this._createRecurringTransactionUseCase,
    this._updateRecurringTransactionUseCase,
    this._getCategoriesUseCase,
  ) : super(RecurringFormState.initial()) {
    on<RecurringFormLoadRequested>(_onLoadRequested);
    on<RecurringFormSubmitted>(_onSubmitted);
    on<RecurringFormTypeChanged>(_onTypeChanged);
    on<RecurringFormCategoryChanged>(_onCategoryChanged);
    on<RecurringFormFrequencyChanged>(_onFrequencyChanged);
    on<RecurringFormNextExecutionChanged>(_onNextExecutionChanged);
  }

  final GetRecurringTransactionByIdUseCase _getRecurringTransactionByIdUseCase;
  final CreateRecurringTransactionUseCase _createRecurringTransactionUseCase;
  final UpdateRecurringTransactionUseCase _updateRecurringTransactionUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadRequested(
    RecurringFormLoadRequested event,
    Emitter<RecurringFormState> emit,
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

      if (event.recurringId == null) {
        emit(
          RecurringFormState.initial(
            type: type,
            categories: categories,
            selectedCategoryId:
                categories.isNotEmpty ? categories.first.id : null,
            nextExecutionDate: DateTime.now(),
          ).copyWith(status: BaseStatus.success),
        );
        return;
      }

      final recurring = await _getRecurringTransactionByIdUseCase(
        GetRecurringTransactionByIdParams(id: event.recurringId!),
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

      final editCategories = await _getCategoriesUseCase(
        GetCategoriesParams(
          type: recurring.type == TransactionType.income
              ? CategoryType.income
              : CategoryType.expense,
        ),
      );

      emit(
        state.copyWith(
          status: BaseStatus.success,
          recurringId: recurring.id,
          type: recurring.type,
          categories: editCategories,
          selectedCategoryId: recurring.category.id,
          frequency: recurring.frequency,
          initialAmount: recurring.amount,
          initialNote: recurring.note,
          nextExecutionDate: recurring.nextExecutionDate,
          isEditing: true,
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

  Future<void> _onSubmitted(
    RecurringFormSubmitted event,
    Emitter<RecurringFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      if (state.selectedCategoryId == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: RecurringTransactionErrorCode.categoryRequired,
          ),
        );
        return;
      }

      final nextExecution = state.nextExecutionDate ?? DateTime.now();

      if (state.isEditing && state.recurringId != null) {
        await _updateRecurringTransactionUseCase(
          UpdateRecurringTransactionParams(
            id: state.recurringId!,
            type: state.type,
            amount: event.amount,
            categoryId: state.selectedCategoryId!,
            frequency: state.frequency,
            nextExecutionDate: nextExecution,
            note: event.note,
          ),
        );
      } else {
        await _createRecurringTransactionUseCase(
          CreateRecurringTransactionParams(
            type: state.type,
            amount: event.amount,
            categoryId: state.selectedCategoryId!,
            frequency: state.frequency,
            nextExecutionDate: nextExecution,
            note: event.note,
          ),
        );
      }

      emit(state.copyWith(status: BaseStatus.success, saved: true));
    } on RecurringTransactionException catch (error) {
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
          errorCode: RecurringTransactionErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onTypeChanged(
    RecurringFormTypeChanged event,
    Emitter<RecurringFormState> emit,
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
          errorCode: RecurringTransactionErrorCode.unknown,
        ),
      );
    }
  }

  void _onCategoryChanged(
    RecurringFormCategoryChanged event,
    Emitter<RecurringFormState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }

  void _onFrequencyChanged(
    RecurringFormFrequencyChanged event,
    Emitter<RecurringFormState> emit,
  ) {
    emit(state.copyWith(frequency: event.frequency));
  }

  void _onNextExecutionChanged(
    RecurringFormNextExecutionChanged event,
    Emitter<RecurringFormState> emit,
  ) {
    emit(state.copyWith(nextExecutionDate: event.nextExecutionDate));
  }
}
