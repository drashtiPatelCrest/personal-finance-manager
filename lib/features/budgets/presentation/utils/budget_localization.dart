import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_error_code.dart';

extension BudgetErrorLocalization on BudgetErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      BudgetErrorCode.nameRequired => l10n.budgetErrorNameRequired,
      BudgetErrorCode.nameTooShort => l10n.budgetErrorNameTooShort,
      BudgetErrorCode.amountInvalid => l10n.budgetErrorAmountInvalid,
      BudgetErrorCode.dateRangeInvalid => l10n.budgetErrorDateRangeInvalid,
      BudgetErrorCode.categoryRequired => l10n.budgetErrorCategoryRequired,
      BudgetErrorCode.categoryNotFound => l10n.budgetErrorCategoryNotFound,
      BudgetErrorCode.categoryTypeMismatch =>
        l10n.budgetErrorCategoryTypeMismatch,
      BudgetErrorCode.budgetNotFound => l10n.budgetErrorNotFound,
      BudgetErrorCode.duplicateName => l10n.budgetErrorDuplicateName,
      BudgetErrorCode.unknown => l10n.budgetErrorUnknown,
    };
  }
}

extension BudgetErrorContext on BuildContext {
  String budgetErrorMessage(BudgetErrorCode code) => code.message(l10n);
}

extension BudgetTypeLocalization on BudgetType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      BudgetType.overall => l10n.budgetTypeOverall,
      BudgetType.category => l10n.budgetTypeCategory,
    };
  }
}

extension BudgetTypeContext on BuildContext {
  String budgetTypeLabel(BudgetType type) => type.label(l10n);
}

extension BudgetStatusLocalization on BudgetStatus {
  String label(AppLocalizations l10n) {
    return switch (this) {
      BudgetStatus.normal => l10n.budgetStatusNormal,
      BudgetStatus.warning => l10n.budgetStatusWarning,
      BudgetStatus.exceeded => l10n.budgetStatusExceeded,
    };
  }
}

extension BudgetStatusContext on BuildContext {
  String budgetStatusLabel(BudgetStatus status) => status.label(l10n);

  String formatBudgetCurrency(num amount) => formatCurrency(amount);
}
