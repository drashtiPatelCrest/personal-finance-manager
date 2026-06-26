import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../transactions/presentation/utils/transaction_localization.dart';
import '../../domain/entities/goal_error_code.dart';
import '../../domain/entities/savings_goal.dart';

extension GoalErrorLocalization on GoalErrorCode {
  String message(AppLocalizations l10n) {
    return switch (this) {
      GoalErrorCode.nameRequired => l10n.goalErrorNameRequired,
      GoalErrorCode.nameTooShort => l10n.goalErrorNameTooShort,
      GoalErrorCode.targetAmountInvalid => l10n.goalErrorTargetAmountInvalid,
      GoalErrorCode.deadlineInvalid => l10n.goalErrorDeadlineInvalid,
      GoalErrorCode.contributionAmountInvalid =>
        l10n.goalErrorContributionAmountInvalid,
      GoalErrorCode.goalNotFound => l10n.goalErrorNotFound,
      GoalErrorCode.goalCompleted => l10n.goalErrorCompleted,
      GoalErrorCode.goalExpired => l10n.goalErrorExpired,
      GoalErrorCode.duplicateName => l10n.goalErrorDuplicateName,
      GoalErrorCode.unknown => l10n.goalErrorUnknown,
    };
  }
}

extension GoalErrorContext on BuildContext {
  String goalErrorMessage(GoalErrorCode code) => code.message(l10n);
}

extension GoalStatusLocalization on GoalStatus {
  String label(AppLocalizations l10n) {
    return switch (this) {
      GoalStatus.active => l10n.goalStatusActive,
      GoalStatus.completed => l10n.goalStatusCompleted,
      GoalStatus.expired => l10n.goalStatusExpired,
    };
  }
}

extension GoalStatusContext on BuildContext {
  String goalStatusLabel(GoalStatus status) => status.label(l10n);

  String formatGoalCurrency(num amount) => formatCurrency(amount);
}
