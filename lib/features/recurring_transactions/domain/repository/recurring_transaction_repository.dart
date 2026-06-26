import '../entities/recurring_transaction.dart';
import '../entities/recurring_transaction_params.dart';

abstract class RecurringTransactionRepository {
  Stream<List<RecurringTransaction>> watchRecurringTransactions({
    bool? isPaused,
    String? query,
  });

  Future<List<RecurringTransaction>> getRecurringTransactions({
    bool? isPaused,
    String? query,
  });

  Future<RecurringTransaction?> getRecurringTransactionById(String id);

  Future<RecurringTransaction> createRecurringTransaction(
    CreateRecurringTransactionParams params,
  );

  Future<RecurringTransaction> updateRecurringTransaction(
    UpdateRecurringTransactionParams params,
  );

  Future<void> deleteRecurringTransaction(String id);

  Future<RecurringTransaction> pauseRecurringTransaction(String id);

  Future<RecurringTransaction> resumeRecurringTransaction(String id);

  Future<int> processDueTransactions({DateTime? referenceDate});
}
