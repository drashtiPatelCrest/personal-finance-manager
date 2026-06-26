import 'package:injectable/injectable.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_params.dart';
import '../../domain/repository/transaction_repository.dart';
import '../datasource/transaction_local_datasource.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._localDataSource);

  final TransactionLocalDataSource _localDataSource;

  @override
  Future<List<Transaction>> getTransactions({TransactionFilter? filter}) {
    return _localDataSource.getTransactions(filter: filter);
  }

  @override
  Future<Transaction?> getTransactionById(String id) {
    return _localDataSource.getTransactionById(id);
  }

  @override
  Future<Transaction> createTransaction(CreateTransactionParams params) {
    return _localDataSource.createTransaction(params);
  }

  @override
  Future<Transaction> updateTransaction(UpdateTransactionParams params) {
    return _localDataSource.updateTransaction(params);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return _localDataSource.deleteTransaction(id);
  }

  @override
  Future<Map<String, num>> getSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _localDataSource.getSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Stream<List<Transaction>> watchTransactions({TransactionFilter? filter}) {
    return _localDataSource.watchTransactions(filter: filter);
  }
}
