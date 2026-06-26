import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_error_code.dart';

extension TransactionErrorLocalization on TransactionErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      TransactionErrorCode.amountRequired =>
        l10n.transactionErrorAmountRequired,
      TransactionErrorCode.amountInvalid => l10n.transactionErrorAmountInvalid,
      TransactionErrorCode.categoryRequired =>
        l10n.transactionErrorCategoryRequired,
      TransactionErrorCode.categoryNotFound =>
        l10n.transactionErrorCategoryNotFound,
      TransactionErrorCode.categoryTypeMismatch =>
        l10n.transactionErrorCategoryTypeMismatch,
      TransactionErrorCode.transactionNotFound =>
        l10n.transactionErrorNotFound,
      TransactionErrorCode.noteTooLong => l10n.transactionErrorNoteTooLong,
      TransactionErrorCode.unknown => l10n.transactionErrorUnknown,
    };
  }
}

extension TransactionErrorContext on BuildContext {
  String transactionErrorMessage(TransactionErrorCode code) =>
      code.message(l10n);
}

extension TransactionTypeLocalization on TransactionType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      TransactionType.income => l10n.categoryTypeIncome,
      TransactionType.expense => l10n.categoryTypeExpense,
    };
  }
}

extension TransactionTypeContext on BuildContext {
  String transactionTypeLabel(TransactionType type) => type.label(l10n);
}

extension TransactionCurrencyFormatting on BuildContext {
  String formatCurrency(num amount) {
    final currencyState = watch<CurrencyCubit>().state;
    return NumberFormat.currency(symbol: currencyState.symbol, decimalDigits: 2)
        .format(amount);
  }
}
