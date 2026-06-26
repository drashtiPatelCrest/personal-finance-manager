import '../entities/transaction.dart';
import '../entities/transaction_params.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions({TransactionFilter? filter});

  Future<Transaction?> getTransactionById(String id);

  Future<Transaction> createTransaction(CreateTransactionParams params);

  Future<Transaction> updateTransaction(UpdateTransactionParams params);

  Future<void> deleteTransaction(String id);

  Future<Map<String, num>> getSummary({
    required DateTime startDate,
    required DateTime endDate,
  });

  Stream<List<Transaction>> watchTransactions({TransactionFilter? filter});
}
