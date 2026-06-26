/// Local report error codes mapped to localized messages in the UI.
enum ReportErrorCode {
  unknown,
}

class ReportException implements Exception {
  const ReportException(this.code);

  final ReportErrorCode code;
}
