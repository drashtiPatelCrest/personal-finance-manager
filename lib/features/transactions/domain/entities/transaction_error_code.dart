/// Local transaction error codes mapped to localized messages in the UI.
enum TransactionErrorCode {
  amountRequired,
  amountInvalid,
  categoryRequired,
  categoryNotFound,
  categoryTypeMismatch,
  transactionNotFound,
  noteTooLong,
  unknown,
}

class TransactionException implements Exception {
  const TransactionException(this.code);

  final TransactionErrorCode code;
}
