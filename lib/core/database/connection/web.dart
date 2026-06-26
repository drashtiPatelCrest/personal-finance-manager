import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

LazyDatabase connect() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'personal_finance_manager',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // Fallback for browsers without required WASM features.
      return result.resolvedExecutor;
    }

    return result.resolvedExecutor;
  });
}
