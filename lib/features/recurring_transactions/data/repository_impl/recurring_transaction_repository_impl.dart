import 'package:injectable/injectable.dart';

import '../../domain/entities/recurring_transaction.dart';
import '../../domain/entities/recurring_transaction_params.dart';
import '../../domain/repository/recurring_transaction_repository.dart';
import '../datasource/recurring_transaction_local_datasource.dart';

@LazySingleton(as: RecurringTransactionRepository)
class RecurringTransactionRepositoryImpl
    implements RecurringTransactionRepository {
  RecurringTransactionRepositoryImpl(this._dataSource);

  final RecurringTransactionLocalDataSource _dataSource;

  @override
  Future<RecurringTransaction> createRecurringTransaction(
    CreateRecurringTransactionParams params,
  ) {
    return _dataSource.createRecurringTransaction(params);
  }

  @override
  Future<void> deleteRecurringTransaction(String id) {
    return _dataSource.deleteRecurringTransaction(id);
  }

  @override
  Future<RecurringTransaction?> getRecurringTransactionById(String id) {
    return _dataSource.getRecurringTransactionById(id);
  }

  @override
  Future<List<RecurringTransaction>> getRecurringTransactions({
    bool? isPaused,
    String? query,
  }) {
    return _dataSource.getRecurringTransactions(
      isPaused: isPaused,
      query: query,
    );
  }

  @override
  Future<RecurringTransaction> pauseRecurringTransaction(String id) {
    return _dataSource.pauseRecurringTransaction(id);
  }

  @override
  Future<int> processDueTransactions({DateTime? referenceDate}) {
    return _dataSource.processDueTransactions(referenceDate: referenceDate);
  }

  @override
  Future<RecurringTransaction> resumeRecurringTransaction(String id) {
    return _dataSource.resumeRecurringTransaction(id);
  }

  @override
  Future<RecurringTransaction> updateRecurringTransaction(
    UpdateRecurringTransactionParams params,
  ) {
    return _dataSource.updateRecurringTransaction(params);
  }

  @override
  Stream<List<RecurringTransaction>> watchRecurringTransactions({
    bool? isPaused,
    String? query,
  }) {
    return _dataSource.watchRecurringTransactions(
      isPaused: isPaused,
      query: query,
    );
  }
}
