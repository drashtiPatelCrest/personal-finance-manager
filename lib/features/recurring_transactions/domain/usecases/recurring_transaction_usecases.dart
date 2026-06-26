import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/recurring_transaction.dart';
import '../entities/recurring_transaction_params.dart';
import '../repository/recurring_transaction_repository.dart';

@injectable
class WatchRecurringTransactionsUseCase
    implements
        UseCase<Stream<List<RecurringTransaction>>,
            WatchRecurringTransactionsParams> {
  WatchRecurringTransactionsUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<Stream<List<RecurringTransaction>>> call(
    WatchRecurringTransactionsParams params,
  ) async {
    return _repository.watchRecurringTransactions(
      isPaused: params.isPaused,
      query: params.query,
    );
  }
}

@injectable
class GetRecurringTransactionsUseCase
    implements
        UseCase<List<RecurringTransaction>, GetRecurringTransactionsParams> {
  GetRecurringTransactionsUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<List<RecurringTransaction>> call(
    GetRecurringTransactionsParams params,
  ) {
    return _repository.getRecurringTransactions(
      isPaused: params.isPaused,
      query: params.query,
    );
  }
}

@injectable
class GetRecurringTransactionByIdUseCase
    implements
        UseCase<RecurringTransaction?, GetRecurringTransactionByIdParams> {
  GetRecurringTransactionByIdUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<RecurringTransaction?> call(GetRecurringTransactionByIdParams params) {
    return _repository.getRecurringTransactionById(params.id);
  }
}

@injectable
class CreateRecurringTransactionUseCase
    implements
        UseCase<RecurringTransaction, CreateRecurringTransactionParams> {
  CreateRecurringTransactionUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<RecurringTransaction> call(CreateRecurringTransactionParams params) {
    return _repository.createRecurringTransaction(params);
  }
}

@injectable
class UpdateRecurringTransactionUseCase
    implements
        UseCase<RecurringTransaction, UpdateRecurringTransactionParams> {
  UpdateRecurringTransactionUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<RecurringTransaction> call(UpdateRecurringTransactionParams params) {
    return _repository.updateRecurringTransaction(params);
  }
}

@injectable
class DeleteRecurringTransactionUseCase
    implements UseCase<void, DeleteRecurringTransactionParams> {
  DeleteRecurringTransactionUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<void> call(DeleteRecurringTransactionParams params) {
    return _repository.deleteRecurringTransaction(params.id);
  }
}

@injectable
class PauseRecurringTransactionUseCase
    implements UseCase<RecurringTransaction, RecurringTransactionIdParams> {
  PauseRecurringTransactionUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<RecurringTransaction> call(RecurringTransactionIdParams params) {
    return _repository.pauseRecurringTransaction(params.id);
  }
}

@injectable
class ResumeRecurringTransactionUseCase
    implements UseCase<RecurringTransaction, RecurringTransactionIdParams> {
  ResumeRecurringTransactionUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<RecurringTransaction> call(RecurringTransactionIdParams params) {
    return _repository.resumeRecurringTransaction(params.id);
  }
}

@injectable
class ProcessDueRecurringTransactionsUseCase implements UseCase<int, NoParams> {
  ProcessDueRecurringTransactionsUseCase(this._repository);

  final RecurringTransactionRepository _repository;

  @override
  Future<int> call(NoParams params) {
    return _repository.processDueTransactions();
  }
}
