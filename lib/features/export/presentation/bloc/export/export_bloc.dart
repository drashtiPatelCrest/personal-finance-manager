import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/bloc/base_state.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../reports/domain/entities/financial_report.dart';
import '../../../../settings/domain/usecases/settings_usecases.dart';
import '../../../domain/entities/export_error_code.dart';
import '../../../domain/entities/export_labels.dart';
import '../../../domain/entities/export_params.dart';
import '../../../domain/entities/export_result.dart';
import '../../../domain/repository/export_repository.dart';
import '../../../domain/usecases/export_usecases.dart';

part 'export_event.dart';
part 'export_state.dart';

@injectable
class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc(
    this._exportDataUseCase,
    this._shareExportUseCase,
    this._getPreferencesUseCase,
  ) : super(ExportState.initial()) {
    on<ExportStarted>(_onStarted);
    on<ExportDateRangeChanged>(_onDateRangeChanged);
    on<ExportDateFilterToggled>(_onDateFilterToggled);
    on<ExportRequested>(_onExportRequested);
    on<ExportShareRequested>(_onShareRequested);
  }

  final ExportDataUseCase _exportDataUseCase;
  final ShareExportUseCase _shareExportUseCase;
  final GetPreferencesUseCase _getPreferencesUseCase;
  int _exportGeneration = 0;

  Future<void> _onStarted(
    ExportStarted event,
    Emitter<ExportState> emit,
  ) async {
    try {
      final preferences = await _getPreferencesUseCase(const NoParams());
      emit(
        state.copyWith(
          dateRangePreset: preferences.export.dateRangePreset,
          useDateFilter: preferences.export.useDateFilter,
        ),
      );
    } catch (_) {
      // Keep default export preferences when loading fails.
    }
  }

  void _onDateRangeChanged(
    ExportDateRangeChanged event,
    Emitter<ExportState> emit,
  ) {
    emit(state.copyWith(dateRangePreset: event.preset));
  }

  void _onDateFilterToggled(
    ExportDateFilterToggled event,
    Emitter<ExportState> emit,
  ) {
    emit(state.copyWith(useDateFilter: event.enabled));
  }

  Future<void> _onExportRequested(
    ExportRequested event,
    Emitter<ExportState> emit,
  ) async {
    final generation = ++_exportGeneration;
    emit(
      state.copyWith(
        status: BaseStatus.loading,
        clearError: true,
        exportingDataType: event.dataType,
        exportingFormat: event.format,
      ),
    );

    try {
      final dateRange = _resolveDateRange(event.dataType);
      final result = await _exportDataUseCase(
        ExportDataParams(
          dataType: event.dataType,
          format: event.format,
          labels: event.labels,
          startDate: dateRange?.startDate,
          endDate: dateRange?.endDate,
        ),
      );

      if (generation != _exportGeneration) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.success,
          lastResult: result,
          clearError: true,
          successNonce: state.successNonce + 1,
          clearExporting: true,
        ),
      );
    } on ExportException catch (error) {
      if (generation != _exportGeneration) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: error.code,
          errorNonce: state.errorNonce + 1,
          clearExporting: true,
        ),
      );
    } catch (_) {
      if (generation != _exportGeneration) {
        return;
      }

      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: ExportErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
          clearExporting: true,
        ),
      );
    }
  }

  Future<void> _onShareRequested(
    ExportShareRequested event,
    Emitter<ExportState> emit,
  ) async {
    try {
      await _shareExportUseCase(
        ShareExportParams(
          filePath: event.filePath,
          format: event.format,
          dataType: event.dataType,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorCode: ExportErrorCode.unknown,
          errorNonce: state.errorNonce + 1,
        ),
      );
    }
  }

  ({DateTime startDate, DateTime endDate})? _resolveDateRange(
    ExportDataType dataType,
  ) {
    if (!state.useDateFilter) {
      return null;
    }

    if (dataType != ExportDataType.transactions &&
        dataType != ExportDataType.reports) {
      return null;
    }

    return state.dateRangePreset.resolve();
  }
}
