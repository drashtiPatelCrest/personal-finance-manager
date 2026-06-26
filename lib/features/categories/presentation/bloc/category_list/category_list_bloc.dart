import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/category_error_code.dart';
import '../../../domain/entities/category_params.dart';
import '../../../domain/usecases/category_usecases.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

@injectable
class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc(
    this._watchCategoriesUseCase,
    this._deleteCategoryUseCase,
  ) : super(const CategoryListState()) {
    on<CategoryListStarted>(_onStarted);
    on<CategoryListSearchChanged>(_onSearchChanged);
    on<CategoryListTypeFilterChanged>(_onTypeFilterChanged);
    on<CategoryListDeleteRequested>(_onDeleteRequested);
    on<CategoryListUpdated>(_onUpdated);
    on<CategoryListFailed>(_onFailed);
  }

  final WatchCategoriesUseCase _watchCategoriesUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;
  StreamSubscription<List<Category>>? _subscription;

  Future<void> _onStarted(
    CategoryListStarted event,
    Emitter<CategoryListState> emit,
  ) async {
    final selectedType = event.initialType ?? state.selectedType;
    emit(
      state.copyWith(
        status: BaseStatus.loading,
        selectedType: selectedType,
        clearError: true,
      ),
    );

    await _subscription?.cancel();
    try {
      final stream = await _watchCategoriesUseCase(
        WatchCategoriesParams(
          type: selectedType,
          query: state.searchQuery,
        ),
      );

      _subscription = stream.listen(
        (categories) => add(CategoryListUpdated(categories)),
        onError: (_) => add(const CategoryListFailed(CategoryErrorCode.unknown)),
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

  Future<void> _onSearchChanged(
    CategoryListSearchChanged event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(CategoryListStarted(initialType: state.selectedType));
  }

  Future<void> _onTypeFilterChanged(
    CategoryListTypeFilterChanged event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedType: event.type,
        clearSelectedType: event.type == null,
      ),
    );
    add(CategoryListStarted(initialType: event.type));
  }

  Future<void> _onDeleteRequested(
    CategoryListDeleteRequested event,
    Emitter<CategoryListState> emit,
  ) async {
    try {
      await _deleteCategoryUseCase(DeleteCategoryParams(id: event.categoryId));
      emit(state.copyWith(clearError: true));
    } on CategoryException catch (error) {
      emit(state.copyWith(clearError: true));
      emit(
        state.copyWith(
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      emit(state.copyWith(clearError: true));
      emit(
        state.copyWith(
          errorCode: CategoryErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  void _onUpdated(CategoryListUpdated event, Emitter<CategoryListState> emit) {
    emit(
      state.copyWith(
        status: BaseStatus.success,
        categories: event.categories,
        clearError: true,
      ),
    );
  }

  void _onFailed(CategoryListFailed event, Emitter<CategoryListState> emit) {
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
