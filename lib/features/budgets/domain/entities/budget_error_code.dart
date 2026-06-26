/// Local budget error codes mapped to localized messages in the UI.
enum BudgetErrorCode {
  nameRequired,
  nameTooShort,
  amountInvalid,
  dateRangeInvalid,
  categoryRequired,
  categoryNotFound,
  categoryTypeMismatch,
  budgetNotFound,
  duplicateName,
  unknown,
}

class BudgetException implements Exception {
  const BudgetException(this.code);

  final BudgetErrorCode code;
}
