import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/recurring_transaction_dao.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../transactions/data/datasource/transaction_local_datasource.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_params.dart';
import '../../domain/entities/recurrence_schedule.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../../domain/entities/recurring_transaction_error_code.dart';
import '../../domain/entities/recurring_transaction_params.dart';

@lazySingleton
class RecurringTransactionLocalDataSource {
  RecurringTransactionLocalDataSource(
    this._database,
    this._transactionDataSource,
  );

  final db.AppDatabase _database;
  final TransactionLocalDataSource _transactionDataSource;
  final Uuid _uuid = const Uuid();

  static const int _maxNoteLength = 500;

  Stream<List<RecurringTransaction>> watchRecurringTransactions({
    bool? isPaused,
    String? query,
  }) {
    return _database.recurringTransactionDao
        .watchRecurringTransactions(isPaused: isPaused, query: query)
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<RecurringTransaction>> getRecurringTransactions({
    bool? isPaused,
    String? query,
  }) async {
    final rows = await _database.recurringTransactionDao.getRecurringTransactions(
      isPaused: isPaused,
      query: query,
    );
    return rows.map(_mapRow).toList();
  }

  Future<RecurringTransaction?> getRecurringTransactionById(String id) async {
    final row =
        await _database.recurringTransactionDao.getRecurringTransactionById(id);
    return row == null ? null : _mapRow(row);
  }

  Future<RecurringTransaction> createRecurringTransaction(
    CreateRecurringTransactionParams params,
  ) async {
    _validateAmount(params.amount);
    _validateNote(params.note);

    final category = await _resolveCategory(
      categoryId: params.categoryId,
      type: params.type,
    );

    final now = DateTime.now();
    final id = _uuid.v4();
    final nextExecution = RecurrenceSchedule.advanceUntilFuture(
      frequency: params.frequency,
      nextExecution: params.nextExecutionDate,
    );
    _validateNextExecutionDate(nextExecution);

    await _database.recurringTransactionDao.insertRecurringTransaction(
      db.RecurringTransactionsCompanion.insert(
        id: id,
        categoryId: category.id,
        type: _encodeType(params.type)!,
        amount: params.amount,
        frequency: _encodeFrequency(params.frequency)!,
        nextExecutionDate: nextExecution,
        isPaused: const Value(false),
        note: Value(params.note.trim()),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final created = await getRecurringTransactionById(id);
    if (created == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    return created;
  }

  Future<RecurringTransaction> updateRecurringTransaction(
    UpdateRecurringTransactionParams params,
  ) async {
    _validateAmount(params.amount);
    _validateNote(params.note);

    final existing = await getRecurringTransactionById(params.id);
    if (existing == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.notFound,
      );
    }

    final category = await _resolveCategory(
      categoryId: params.categoryId,
      type: params.type,
    );

    final nextExecution = RecurrenceSchedule.advanceUntilFuture(
      frequency: params.frequency,
      nextExecution: params.nextExecutionDate,
    );
    _validateNextExecutionDate(nextExecution);

    final updated = await _database.recurringTransactionDao.updateRecurringTransaction(
      db.RecurringTransactionsCompanion(
        id: Value(params.id),
        categoryId: Value(category.id),
        type: Value(_encodeType(params.type)!),
        amount: Value(params.amount),
        frequency: Value(_encodeFrequency(params.frequency)!),
        nextExecutionDate: Value(nextExecution),
        note: Value(params.note.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!updated) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    final recurring = await getRecurringTransactionById(params.id);
    if (recurring == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    return recurring;
  }

  Future<void> deleteRecurringTransaction(String id) async {
    final existing = await getRecurringTransactionById(id);
    if (existing == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.notFound,
      );
    }

    final deleted =
        await _database.recurringTransactionDao.deleteRecurringTransaction(id);
    if (!deleted) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }
  }

  Future<RecurringTransaction> pauseRecurringTransaction(String id) async {
    final existing = await getRecurringTransactionById(id);
    if (existing == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.notFound,
      );
    }

    final updated = await _database.recurringTransactionDao.updateRecurringTransaction(
      db.RecurringTransactionsCompanion(
        id: Value(id),
        isPaused: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!updated) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    final recurring = await getRecurringTransactionById(id);
    if (recurring == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    return recurring;
  }

  Future<RecurringTransaction> resumeRecurringTransaction(String id) async {
    final existing = await getRecurringTransactionById(id);
    if (existing == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.notFound,
      );
    }

    final nextExecution = RecurrenceSchedule.advanceUntilFuture(
      frequency: existing.frequency,
      nextExecution: existing.nextExecutionDate,
    );

    final updated = await _database.recurringTransactionDao.updateRecurringTransaction(
      db.RecurringTransactionsCompanion(
        id: Value(id),
        isPaused: const Value(false),
        nextExecutionDate: Value(nextExecution),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!updated) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    final recurring = await getRecurringTransactionById(id);
    if (recurring == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.unknown,
      );
    }

    return recurring;
  }

  Future<int> processDueTransactions({DateTime? referenceDate}) async {
    final now = referenceDate ?? DateTime.now();
    final dueRows =
        await _database.recurringTransactionDao.getDueRecurringTransactions(now);
    var generatedCount = 0;

    for (final row in dueRows) {
      final recurring = await getRecurringTransactionById(row.id);
      if (recurring == null || recurring.isPaused) {
        continue;
      }

      var nextExecution = DateTime(
        recurring.nextExecutionDate.year,
        recurring.nextExecutionDate.month,
        recurring.nextExecutionDate.day,
      );
      var itemGeneratedCount = 0;

      await _database.transaction(() async {
        while (RecurrenceSchedule.isDue(
          nextExecution: nextExecution,
          referenceDate: now,
        )) {
          await _transactionDataSource.createTransaction(
            CreateTransactionParams(
              type: recurring.type,
              amount: recurring.amount,
              categoryId: recurring.category.id,
              date: nextExecution,
              note: recurring.note,
            ),
          );
          itemGeneratedCount++;
          nextExecution = RecurrenceSchedule.calculateNextExecution(
            frequency: recurring.frequency,
            from: nextExecution,
          );
        }

        await _database.recurringTransactionDao.updateRecurringTransaction(
          db.RecurringTransactionsCompanion(
            id: Value(recurring.id),
            nextExecutionDate: Value(nextExecution),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });

      generatedCount += itemGeneratedCount;
    }

    return generatedCount;
  }

  Future<Category> _resolveCategory({
    required String categoryId,
    required TransactionType type,
  }) async {
    if (categoryId.trim().isEmpty) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.categoryRequired,
      );
    }

    final row = await _database.categoryDao.getCategoryById(categoryId);
    if (row == null) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.categoryNotFound,
      );
    }

    final category = _mapCategoryRow(row);
    final expectedCategoryType = type == TransactionType.income
        ? CategoryType.income
        : CategoryType.expense;
    if (category.type != expectedCategoryType) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.categoryTypeMismatch,
      );
    }
    return category;
  }

  void _validateAmount(double amount) {
    if (amount.isNaN || amount <= 0) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.amountInvalid,
      );
    }
  }

  void _validateNote(String note) {
    if (note.trim().length > _maxNoteLength) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.noteTooLong,
      );
    }
  }

  void _validateNextExecutionDate(DateTime date) {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final executionDay = DateTime(date.year, date.month, date.day);
    if (executionDay.isBefore(startOfToday)) {
      throw const RecurringTransactionException(
        RecurringTransactionErrorCode.nextExecutionInvalid,
      );
    }
  }

  RecurringTransaction _mapRow(RecurringTransactionWithCategory row) {
    return RecurringTransaction(
      id: row.recurringTransaction.id,
      type: _decodeType(row.recurringTransaction.type),
      amount: row.recurringTransaction.amount,
      category: _mapCategoryRow(row.category),
      frequency: _decodeFrequency(row.recurringTransaction.frequency),
      nextExecutionDate: row.recurringTransaction.nextExecutionDate,
      isPaused: row.recurringTransaction.isPaused,
      note: row.recurringTransaction.note,
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

  String? _encodeFrequency(RecurrenceFrequency? frequency) {
    return switch (frequency) {
      RecurrenceFrequency.daily => 'daily',
      RecurrenceFrequency.weekly => 'weekly',
      RecurrenceFrequency.monthly => 'monthly',
      RecurrenceFrequency.yearly => 'yearly',
      null => null,
    };
  }

  RecurrenceFrequency _decodeFrequency(String value) {
    return switch (value) {
      'daily' => RecurrenceFrequency.daily,
      'weekly' => RecurrenceFrequency.weekly,
      'monthly' => RecurrenceFrequency.monthly,
      _ => RecurrenceFrequency.yearly,
    };
  }

  CategoryType _decodeCategoryType(String value) {
    return switch (value) {
      'income' => CategoryType.income,
      _ => CategoryType.expense,
    };
  }
}
