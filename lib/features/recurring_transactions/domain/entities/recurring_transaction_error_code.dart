/// Local recurring transaction error codes mapped to localized messages.
enum RecurringTransactionErrorCode {
  amountInvalid,
  categoryRequired,
  categoryNotFound,
  categoryTypeMismatch,
  noteTooLong,
  nextExecutionInvalid,
  notFound,
  unknown,
}

class RecurringTransactionException implements Exception {
  const RecurringTransactionException(this.code);

  final RecurringTransactionErrorCode code;
}
