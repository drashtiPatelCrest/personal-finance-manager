import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/transaction_dao.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_error_code.dart';
import '../../domain/entities/transaction_params.dart';

@lazySingleton
class TransactionLocalDataSource {
  TransactionLocalDataSource(this._database);

  final db.AppDatabase _database;
  final Uuid _uuid = const Uuid();

  static const int _maxNoteLength = 500;

  Stream<List<Transaction>> watchTransactions({TransactionFilter? filter}) {
    return _database.transactionDao
        .watchTransactions(
          type: _encodeType(filter?.type),
          categoryId: filter?.categoryId,
          startDate: filter?.startDate,
          endDate: filter?.endDate,
          query: filter?.query,
        )
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<Transaction>> getTransactions({TransactionFilter? filter}) async {
    final rows = await _database.transactionDao.getTransactions(
      type: _encodeType(filter?.type),
      categoryId: filter?.categoryId,
      startDate: filter?.startDate,
      endDate: filter?.endDate,
      query: filter?.query,
    );
    return rows.map(_mapRow).toList();
  }

  Future<Transaction?> getTransactionById(String id) async {
    final row = await _database.transactionDao.getTransactionById(id);
    return row == null ? null : _mapRow(row);
  }

  Future<Transaction> createTransaction(CreateTransactionParams params) async {
    _validateAmount(params.amount);
    _validateNote(params.note);
    final category = await _resolveCategory(
      categoryId: params.categoryId,
      type: params.type,
    );

    final id = _uuid.v4();
    await _database.transactionDao.insertTransaction(
      db.TransactionsCompanion.insert(
        id: id,
        categoryId: category.id,
        type: _encodeType(params.type)!,
        amount: params.amount,
        date: params.date,
        note: Value(params.note.trim()),
      ),
    );

    final created = await getTransactionById(id);
    if (created == null) {
      throw const TransactionException(TransactionErrorCode.unknown);
    }
    return created;
  }

  Future<Transaction> updateTransaction(UpdateTransactionParams params) async {
    _validateAmount(params.amount);
    _validateNote(params.note);

    final existing = await getTransactionById(params.id);
    if (existing == null) {
      throw const TransactionException(TransactionErrorCode.transactionNotFound);
    }

    final category = await _resolveCategory(
      categoryId: params.categoryId,
      type: params.type,
    );

    final updated = await _database.transactionDao.updateTransaction(
      db.TransactionsCompanion(
        id: Value(params.id),
        categoryId: Value(category.id),
        type: Value(_encodeType(params.type)!),
        amount: Value(params.amount),
        date: Value(params.date),
        note: Value(params.note.trim()),
      ),
    );
    if (!updated) {
      throw const TransactionException(TransactionErrorCode.unknown);
    }

    final transaction = await getTransactionById(params.id);
    if (transaction == null) {
      throw const TransactionException(TransactionErrorCode.unknown);
    }
    return transaction;
  }

  Future<void> deleteTransaction(String id) async {
    final existing = await getTransactionById(id);
    if (existing == null) {
      throw const TransactionException(TransactionErrorCode.transactionNotFound);
    }

    final deleted = await _database.transactionDao.deleteTransaction(id);
    if (!deleted) {
      throw const TransactionException(TransactionErrorCode.unknown);
    }
  }

  Future<Map<String, num>> getSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _database.transactionDao.getSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<double> sumExpenses({
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  }) {
    return _database.transactionDao.sumExpenses(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );
  }

  Future<Category> _resolveCategory({
    required String categoryId,
    required TransactionType type,
  }) async {
    if (categoryId.trim().isEmpty) {
      throw const TransactionException(TransactionErrorCode.categoryRequired);
    }

    final row = await _database.categoryDao.getCategoryById(categoryId);
    if (row == null) {
      throw const TransactionException(TransactionErrorCode.categoryNotFound);
    }

    final category = _mapCategoryRow(row);
    final expectedCategoryType = type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    if (category.type != expectedCategoryType) {
      throw const TransactionException(
        TransactionErrorCode.categoryTypeMismatch,
      );
    }
    return category;
  }

  void _validateAmount(double amount) {
    if (amount.isNaN) {
      throw const TransactionException(TransactionErrorCode.amountInvalid);
    }
    if (amount <= 0) {
      throw const TransactionException(TransactionErrorCode.amountInvalid);
    }
  }

  void _validateNote(String note) {
    if (note.trim().length > _maxNoteLength) {
      throw const TransactionException(TransactionErrorCode.noteTooLong);
    }
  }

  Transaction _mapRow(TransactionWithCategory row) {
    return Transaction(
      id: row.transaction.id,
      type: _decodeType(row.transaction.type),
      amount: row.transaction.amount,
      category: _mapCategoryRow(row.category),
      date: row.transaction.date,
      note: row.transaction.note,
    );
  }

  Category _mapCategoryRow(db.Category row) {
    return Category(
      id: row.id,
      name: row.name,
      type: _decodeCategoryType(row.type),
      iconCode: row.iconCode,
      colorValue: row.colorValue,
    );
  }

  String? _encodeType(TransactionType? type) {
    return switch (type) {
      TransactionType.income => 'income',
      TransactionType.expense => 'expense',
      null => null,
    };
  }

  TransactionType _decodeType(String value) {
    return switch (value) {
      'income' => TransactionType.income,
      _ => TransactionType.expense,
    };
  }

  CategoryType _decodeCategoryType(String value) {
    return switch (value) {
      'income' => CategoryType.income,
      _ => CategoryType.expense,
    };
  }
}
