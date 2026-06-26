/// Local goal error codes mapped to localized messages in the UI.
enum GoalErrorCode {
  nameRequired,
  nameTooShort,
  targetAmountInvalid,
  deadlineInvalid,
  contributionAmountInvalid,
  goalNotFound,
  goalCompleted,
  goalExpired,
  duplicateName,
  unknown,
}

class GoalException implements Exception {
  const GoalException(this.code);

  final GoalErrorCode code;
}
