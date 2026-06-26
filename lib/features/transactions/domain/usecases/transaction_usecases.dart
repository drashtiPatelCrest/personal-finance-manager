import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../entities/transaction_params.dart';
import '../repository/transaction_repository.dart';

@injectable
class WatchTransactionsUseCase
    implements UseCase<Stream<List<Transaction>>, WatchTransactionsParams> {
  WatchTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Stream<List<Transaction>>> call(WatchTransactionsParams params) async {
    return _repository.watchTransactions(filter: params.filter);
  }
}

@injectable
class GetTransactionsUseCase
    implements UseCase<List<Transaction>, GetTransactionsParams> {
  GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<List<Transaction>> call(GetTransactionsParams params) {
    return _repository.getTransactions(filter: params.filter);
  }
}

@injectable
class GetTransactionByIdUseCase
    implements UseCase<Transaction?, GetTransactionByIdParams> {
  GetTransactionByIdUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Transaction?> call(GetTransactionByIdParams params) {
    return _repository.getTransactionById(params.id);
  }
}

@injectable
class CreateTransactionUseCase
    implements UseCase<Transaction, CreateTransactionParams> {
  CreateTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Transaction> call(CreateTransactionParams params) {
    return _repository.createTransaction(params);
  }
}

@injectable
class UpdateTransactionUseCase
    implements UseCase<Transaction, UpdateTransactionParams> {
  UpdateTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Transaction> call(UpdateTransactionParams params) {
    return _repository.updateTransaction(params);
  }
}

@injectable
class DeleteTransactionUseCase
    implements UseCase<void, DeleteTransactionParams> {
  DeleteTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<void> call(DeleteTransactionParams params) {
    return _repository.deleteTransaction(params.id);
  }
}

@injectable
class GetTransactionSummaryUseCase
    implements UseCase<Map<String, num>, GetTransactionSummaryParams> {
  GetTransactionSummaryUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Map<String, num>> call(GetTransactionSummaryParams params) {
    return _repository.getSummary(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
