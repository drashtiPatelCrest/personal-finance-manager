import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../../domain/entities/recurring_transaction_error_code.dart';
import '../../domain/entities/recurring_transaction.dart';

extension RecurringErrorLocalization on RecurringTransactionErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      RecurringTransactionErrorCode.amountInvalid =>
        l10n.recurringErrorAmountInvalid,
      RecurringTransactionErrorCode.categoryRequired =>
        l10n.recurringErrorCategoryRequired,
      RecurringTransactionErrorCode.categoryNotFound =>
        l10n.recurringErrorCategoryNotFound,
      RecurringTransactionErrorCode.categoryTypeMismatch =>
        l10n.recurringErrorCategoryTypeMismatch,
      RecurringTransactionErrorCode.noteTooLong => l10n.recurringErrorNoteTooLong,
      RecurringTransactionErrorCode.nextExecutionInvalid =>
        l10n.recurringErrorNextExecutionInvalid,
      RecurringTransactionErrorCode.notFound => l10n.recurringErrorNotFound,
      RecurringTransactionErrorCode.unknown => l10n.recurringErrorUnknown,
    };
  }
}

extension RecurringErrorContext on BuildContext {
  String recurringErrorMessage(RecurringTransactionErrorCode code) =>
      code.message(l10n);
}

extension RecurrenceFrequencyLocalization on RecurrenceFrequency {
  String label(AppLocalizations l10n) {
    return switch (this) {
      RecurrenceFrequency.daily => l10n.recurringFrequencyDaily,
      RecurrenceFrequency.weekly => l10n.recurringFrequencyWeekly,
      RecurrenceFrequency.monthly => l10n.recurringFrequencyMonthly,
      RecurrenceFrequency.yearly => l10n.recurringFrequencyYearly,
    };
  }
}

extension RecurrenceFrequencyContext on BuildContext {
  String recurrenceFrequencyLabel(RecurrenceFrequency frequency) =>
      frequency.label(l10n);

  String formatRecurringCurrency(num amount) => formatCurrency(amount);
}

extension RecurringStatusContext on BuildContext {
  String recurringStatusLabel(bool isPaused) =>
      isPaused ? l10n.recurringStatusPaused : l10n.recurringStatusActive;
}
