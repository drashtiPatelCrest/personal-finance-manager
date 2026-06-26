/// Local dashboard error codes mapped to localized messages in the UI.
enum DashboardErrorCode {
  unknown,
}

class DashboardException implements Exception {
  const DashboardException(this.code);

  final DashboardErrorCode code;
}
