import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/constants/category_icons.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_error_code.dart';
import '../../../domain/entities/category_params.dart';
import '../../../domain/usecases/category_usecases.dart';

part 'category_form_event.dart';
part 'category_form_state.dart';

@injectable
class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  CategoryFormBloc(
    this._getCategoryByIdUseCase,
    this._createCategoryUseCase,
    this._updateCategoryUseCase,
  ) : super(CategoryFormState.initial()) {
    on<CategoryFormLoadRequested>(_onLoadRequested);
    on<CategoryFormSubmitted>(_onSubmitted);
    on<CategoryFormIconChanged>(_onIconChanged);
    on<CategoryFormColorChanged>(_onColorChanged);
    on<CategoryFormTypeChanged>(_onTypeChanged);
  }

  final GetCategoryByIdUseCase _getCategoryByIdUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;

  Future<void> _onLoadRequested(
    CategoryFormLoadRequested event,
    Emitter<CategoryFormState> emit,
  ) async {
    if (event.categoryId == null) {
      emit(
        CategoryFormState.initial(
          type: event.initialType ?? CategoryType.expense,
        ),
      );
      return;
    }

    emit(state.copyWith(status: BaseStatus.loading));
    try {
      final category = await _getCategoryByIdUseCase(
        GetCategoryByIdParams(id: event.categoryId!),
      );
      if (category == null) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorCode: CategoryErrorCode.categoryNotFound,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          categoryId: category.id,
          type: category.type,
          iconCode: category.iconCode,
          colorValue: category.colorValue,
          initialName: category.name,
          isEditing: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: CategoryErrorCode.unknown,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    CategoryFormSubmitted event,
    Emitter<CategoryFormState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    try {
      if (state.isEditing && state.categoryId != null) {
        await _updateCategoryUseCase(
          UpdateCategoryParams(
            id: state.categoryId!,
            name: event.name,
            type: state.type,
            iconCode: state.iconCode,
            colorValue: state.colorValue,
          ),
        );
      } else {
        await _createCategoryUseCase(
          CreateCategoryParams(
            name: event.name,
            type: state.type,
            iconCode: state.iconCode,
            colorValue: state.colorValue,
          ),
        );
      }

      emit(state.copyWith(status: BaseStatus.success, saved: true));
    } on CategoryException catch (error) {
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
          errorCode: CategoryErrorCode.unknown,
        ),
      );
    }
  }

  void _onIconChanged(
    CategoryFormIconChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(iconCode: event.iconCode));
  }

  void _onColorChanged(
    CategoryFormColorChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(colorValue: event.colorValue));
  }

  void _onTypeChanged(
    CategoryFormTypeChanged event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(type: event.type));
  }
}
