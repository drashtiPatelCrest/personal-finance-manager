/// Local export error codes mapped to localized messages in the UI.
enum ExportErrorCode {
  unknown,
  noData,
  fileWriteFailed,
}

class ExportException implements Exception {
  const ExportException(this.code);

  final ExportErrorCode code;
}
