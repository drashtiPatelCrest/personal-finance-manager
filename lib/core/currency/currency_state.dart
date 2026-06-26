import 'package:equatable/equatable.dart';

import '../constants/currency_constants.dart';

class CurrencyState extends Equatable {
  const CurrencyState({required this.currencyCode});

  final String currencyCode;

  String get symbol => CurrencyConstants.symbolForCode(currencyCode);

  @override
  List<Object?> get props => [currencyCode];
}
