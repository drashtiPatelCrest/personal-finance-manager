import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../categories/domain/entities/category.dart';
import '../../../../categories/domain/entities/category_params.dart';
import '../../../../categories/domain/usecases/category_usecases.dart';
import '../../../domain/entities/financial_report.dart';
import '../../../domain/entities/report_error_code.dart';
import '../../../domain/usecases/report_usecases.dart';

part 'report_detail_event.dart';
part 'report_detail_state.dart';

@injectable
class ReportDetailBloc extends Bloc<ReportDetailEvent, ReportDetailState> {
  ReportDetailBloc(
    this._generateReportUseCase,
    this._getCategoriesUseCase,
  ) : super(ReportDetailState.initial()) {
    on<ReportDetailStarted>(_onStarted);
    on<ReportDetailDateRangeChanged>(_onDateRangeChanged);
    on<ReportDetailCategoryChanged>(_onCategoryChanged);
    on<ReportDetailRefreshRequested>(_onRefreshRequested);
  }

  final GenerateReportUseCase _generateReportUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  int _loadGeneration = 0;

  Future<void> _onStarted(
    ReportDetailStarted event,
    Emitter<ReportDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        reportType: event.reportType,
        dateRangePreset: event.reportType.defaultDateRangePreset(),
        status: BaseStatus.loading,
        clearError: true,
        clearReport: true,
      ),
    );
    await _loadCategories(emit);
    await _loadReport(emit);
  }

  Future<void> _onDateRangeChanged(
    ReportDetailDateRangeChanged event,
    Emitter<ReportDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        dateRangePreset: event.preset,
        status: BaseStatus.loading,
        clearError: true,
        clearReport: true,
      ),
    );
    await _loadReport(emit);
  }

  Future<void> _onCategoryChanged(
    ReportDetailCategoryChanged event,
    Emitter<ReportDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedCategoryId: event.categoryId,
        clearSelectedCategoryId: event.categoryId == null,
        status: BaseStatus.loading,
        clearError: true,
        clearReport: true,
      ),
    );
    await _loadReport(emit);
  }

  Future<void> _onRefreshRequested(
    ReportDetailRefreshRequested event,
    Emitter<ReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));
    await _loadReport(emit);
  }

  Future<void> _loadCategories(Emitter<ReportDetailState> emit) async {
    if (state.reportType == null || !state.reportType!.supportsCategoryFilter()) {
      return;
    }

    try {
      final categories = await _getCategoriesUseCase(const GetCategoriesParams());
      emit(state.copyWith(categories: categories));
    } catch (_) {
      emit(state.copyWith(categories: const []));
    }
  }

  Future<void> _loadReport(Emitter<ReportDetailState> emit) async {
    final reportType = state.reportType;
    if (reportType == null) {
      return;
    }

    final generation = ++_loadGeneration;
    emit(state.copyWith(status: BaseStatus.loading, clearError: true));

    try {
      final range = reportType.supportsDateRangeFilter()
          ? state.dateRangePreset.resolve()
          : null;

      final report = await _generateReportUseCase(
        ReportFilter(
          type: reportType,
          startDate: range?.startDate,
          endDate: range?.endDate,
          categoryId: reportType.supportsCategoryFilter()
              ? state.selectedCategoryId
              : null,
          dateRangePreset: range == null ? null : state.dateRangePreset,
        ),
      );

      if (generation != _loadGeneration) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          report: report,
          clearError: true,
        ),
      );
    } on ReportException catch (error) {
      if (generation != _loadGeneration) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
        ),
      );
    } catch (_) {
      if (generation != _loadGeneration) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: ReportErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }
}
