import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';
import '../tables/transactions_table.dart';

part 'transaction_dao.g.dart';

class TransactionWithCategory {
  const TransactionWithCategory({
    required this.transaction,
    required this.category,
  });

  final Transaction transaction;
  final Category category;
}

@DriftAccessor(tables: [Transactions, Categories])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Stream<List<TransactionWithCategory>> watchTransactions({
    String? type,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    String? query,
  }) {
    final statement = _joinedQuery();
    _applyFilters(
      statement,
      type: type,
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
      query: query,
    );
    statement.orderBy([OrderingTerm.desc(transactions.date)]);
    return statement
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<TransactionWithCategory>> getTransactions({
    String? type,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    String? query,
  }) {
    final statement = _joinedQuery();
    _applyFilters(
      statement,
      type: type,
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
      query: query,
    );
    statement.orderBy([OrderingTerm.desc(transactions.date)]);
    return statement.get().then((rows) => rows.map(_mapRow).toList());
  }

  Future<TransactionWithCategory?> getTransactionById(String id) async {
    final statement = _joinedQuery()
      ..where(transactions.id.equals(id));
    final row = await statement.getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  Future<bool> updateTransaction(TransactionsCompanion transaction) async {
    final updated = await (update(transactions)
          ..where((table) => table.id.equals(transaction.id.value)))
        .write(transaction);
    return updated > 0;
  }

  Future<bool> deleteTransaction(String id) async {
    final deleted =
        await (delete(transactions)..where((table) => table.id.equals(id)))
            .go();
    return deleted > 0;
  }

  Future<Map<String, num>> getSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final start = _startOfDay(startDate);
    final end = _endOfDay(endDate);

    final income = await _sumByType(
      type: 'income',
      start: start,
      end: end,
    );
    final expense = await _sumByType(
      type: 'expense',
      start: start,
      end: end,
    );

    return {
      'income': income,
      'expense': expense,
      'net': income - expense,
    };
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joinedQuery() {
    return select(transactions).join([
      innerJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
    ]);
  }

  void _applyFilters(
    JoinedSelectStatement<HasResultSet, dynamic> statement, {
    String? type,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    String? query,
  }) {
    if (type != null) {
      statement.where(transactions.type.equals(type));
    }
    if (categoryId != null) {
      statement.where(transactions.categoryId.equals(categoryId));
    }
    if (startDate != null) {
      statement.where(
        transactions.date.isBiggerOrEqualValue(_startOfDay(startDate)),
      );
    }
    if (endDate != null) {
      statement.where(
        transactions.date.isSmallerOrEqualValue(_endOfDay(endDate)),
      );
    }
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      statement.where(
        transactions.note.like('%$trimmedQuery%') |
            categories.name.like('%$trimmedQuery%'),
      );
    }
  }

  Future<double> sumExpenses({
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
  }) async {
    final start = _startOfDay(startDate);
    final end = _endOfDay(endDate);
    final amountSum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([amountSum])
      ..where(transactions.type.equals('expense'))
      ..where(transactions.date.isBetweenValues(start, end));

    if (categoryId != null) {
      query.where(transactions.categoryId.equals(categoryId));
    }

    final row = await query.getSingleOrNull();
    return row?.read(amountSum) ?? 0;
  }

  Future<double> _sumByType({
    required String type,
    required DateTime start,
    required DateTime end,
  }) async {
    final amountSum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([amountSum])
      ..where(transactions.type.equals(type))
      ..where(transactions.date.isBetweenValues(start, end));

    final row = await query.getSingleOrNull();
    return row?.read(amountSum) ?? 0;
  }

  TransactionWithCategory _mapRow(TypedResult row) {
    return TransactionWithCategory(
      transaction: row.readTable(transactions),
      category: row.readTable(categories),
    );
  }

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}
