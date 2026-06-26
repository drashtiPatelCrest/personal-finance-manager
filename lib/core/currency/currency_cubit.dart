import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/usecases/usecase.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import '../constants/currency_constants.dart';
import 'currency_state.dart';

@lazySingleton
class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit(this._getPreferencesUseCase, this._updateCurrencyUseCase)
      : super(
          const CurrencyState(
            currencyCode: CurrencyConstants.defaultCurrencyCode,
          ),
        );

  final GetPreferencesUseCase _getPreferencesUseCase;
  final UpdateCurrencyUseCase _updateCurrencyUseCase;

  Future<void> load() async {
    final preferences = await _getPreferencesUseCase(const NoParams());
    emit(CurrencyState(currencyCode: preferences.currencyCode));
  }

  Future<void> setCurrencyCode(String currencyCode) async {
    final preferences = await _updateCurrencyUseCase(
      UpdateCurrencyParams(currencyCode: currencyCode),
    );
    emit(CurrencyState(currencyCode: preferences.currencyCode));
  }
}
