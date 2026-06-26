/// Local category error codes mapped to localized messages in the UI.
enum CategoryErrorCode {
  nameRequired,
  nameTooShort,
  categoryNotFound,
  duplicateName,
  hasTransactions,
  unknown,
}

class CategoryException implements Exception {
  const CategoryException(this.code);

  final CategoryErrorCode code;
}
