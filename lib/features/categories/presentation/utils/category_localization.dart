import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_error_code.dart';

extension CategoryErrorLocalization on CategoryErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      CategoryErrorCode.nameRequired => l10n.categoryErrorNameRequired,
      CategoryErrorCode.nameTooShort => l10n.categoryErrorNameTooShort,
      CategoryErrorCode.categoryNotFound => l10n.categoryErrorNotFound,
      CategoryErrorCode.duplicateName => l10n.categoryErrorDuplicateName,
      CategoryErrorCode.hasTransactions => l10n.categoryErrorHasTransactions,
      CategoryErrorCode.unknown => l10n.categoryErrorUnknown,
    };
  }
}

extension CategoryErrorContext on BuildContext {
  String categoryErrorMessage(CategoryErrorCode code) => code.message(l10n);
}

extension CategoryTypeLocalization on CategoryType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      CategoryType.income => l10n.categoryTypeIncome,
      CategoryType.expense => l10n.categoryTypeExpense,
    };
  }
}

extension CategoryTypeContext on BuildContext {
  String categoryTypeLabel(CategoryType type) => type.label(l10n);
}
