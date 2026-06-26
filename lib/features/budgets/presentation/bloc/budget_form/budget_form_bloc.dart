import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../categories/domain/entities/category.dart';
import '../../../../categories/domain/entities/category_params.dart';
import '../../../../categories/domain/usecases/category_usecases.dart';
import '../../../domain/entities/budget.dart';
import '../../../domain/entities/budget_error_code.dart';
import '../../../domain/entities/budget_params.dart';
import '../../../domain/usecases/budget_usecases.dart';

part 'budget_form_event.dart';
part 'budget_form_state.dart';

@injectable
class BudgetFormBloc extends Bloc<BudgetFormEvent, BudgetFormState> {
  BudgetFormBloc(
    this._getBudgetByIdUseCase,
    this._createBudgetUseCase,
    this._updateBudgetUseCase,
    this._getCategoriesUseCase,
  ) : super(BudgetFormState.initial()) {
    on<BudgetFormLoadRequested>(_onLoadRequested);
    on<BudgetFormSubmitted>(_onSubmitted);
    on<BudgetFormTypeChanged>(_onTypeChanged);
    on<BudgetFormCategoryChanged>(_onCategoryChanged);
    on<BudgetFormStartDateChanged>(_onStartDateChanged);
    on<BudgetFormEndDateChanged>(_onEndDateChanged);
  }

  final GetBudgetByIdUseCase _getBudgetByIdUseCase;
  final CreateBudgetUseCase _createBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _onLoadRequested(
    BudgetFormLoadRequested event,
    Emitter<BudgetFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      final categories = await _getCategoriesUseCase(
        const GetCategoriesParams(type: CategoryType.expense),
      );

      if (event.budgetId == null) {
        final type = event.initialType ?? BudgetType.overall;
        emit(
          BudgetFormState.initial(
            type: type,
            categories: categories,
            selectedCategoryId:
                type == BudgetType.category && categories.isNotEmpty
                    ? categories.first.id
                    : null,
            startDate: DateTime.now(),
            endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
          ).copyWith(status: BaseStatus.success),
        );
        return;
      }

      final budget = await _getBudgetByIdUseCase(
        GetBudgetByIdParams(id: event.budgetId!),
      );
      if (budget == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: BudgetErrorCode.budgetNotFound,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          budgetId: budget.id,
          type: budget.type,
          categories: categories,
          selectedCategoryId: budget.categoryId,
          initialName: budget.name,
          initialAmount: budget.amount,
          startDate: budget.startDate,
          endDate: budget.endDate,
          isEditing: true,
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

  Future<void> _onSubmitted(
    BudgetFormSubmitted event,
    Emitter<BudgetFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      if (state.type == BudgetType.category && state.selectedCategoryId == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: BudgetErrorCode.categoryRequired,
          ),
        );
        return;
      }

      final startDate = state.startDate ?? DateTime.now();
      final endDate = state.endDate ?? startDate;
      final categoryId =
          state.type == BudgetType.overall ? null : state.selectedCategoryId;

      if (state.isEditing && state.budgetId != null) {
        await _updateBudgetUseCase(
          UpdateBudgetParams(
            id: state.budgetId!,
            name: event.name,
            amount: event.amount,
            startDate: startDate,
            endDate: endDate,
            categoryId: categoryId,
          ),
        );
      } else {
        await _createBudgetUseCase(
          CreateBudgetParams(
            name: event.name,
            amount: event.amount,
            startDate: startDate,
            endDate: endDate,
            categoryId: categoryId,
          ),
        );
      }

      emit(state.copyWith(status: BaseStatus.success, saved: true));
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

  void _onTypeChanged(
    BudgetFormTypeChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    if (state.isEditing) {
      return;
    }

    emit(
      state.copyWith(
        type: event.type,
        selectedCategoryId: event.type == BudgetType.category &&
                state.categories.isNotEmpty
            ? state.categories.first.id
            : null,
        clearSelectedCategoryId: event.type == BudgetType.overall,
      ),
    );
  }

  void _onCategoryChanged(
    BudgetFormCategoryChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }

  void _onStartDateChanged(
    BudgetFormStartDateChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(startDate: event.date));
  }

  void _onEndDateChanged(
    BudgetFormEndDateChanged event,
    Emitter<BudgetFormState> emit,
  ) {
    emit(state.copyWith(endDate: event.date));
  }
}
