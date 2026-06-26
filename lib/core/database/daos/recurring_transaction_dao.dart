import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';
import '../tables/recurring_transactions_table.dart';

part 'recurring_transaction_dao.g.dart';

class RecurringTransactionWithCategory {
  const RecurringTransactionWithCategory({
    required this.recurringTransaction,
    required this.category,
  });

  final RecurringTransaction recurringTransaction;
  final Category category;
}

@DriftAccessor(tables: [RecurringTransactions, Categories])
class RecurringTransactionDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringTransactionDaoMixin {
  RecurringTransactionDao(super.db);

  Stream<List<RecurringTransactionWithCategory>> watchRecurringTransactions({
    bool? isPaused,
    String? query,
  }) {
    final statement = _joinedQuery();
    _applyFilters(statement, isPaused: isPaused, query: query);
    statement.orderBy([
      OrderingTerm.asc(recurringTransactions.nextExecutionDate),
    ]);
    return statement.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<RecurringTransactionWithCategory>> getRecurringTransactions({
    bool? isPaused,
    String? query,
  }) {
    final statement = _joinedQuery();
    _applyFilters(statement, isPaused: isPaused, query: query);
    statement.orderBy([
      OrderingTerm.asc(recurringTransactions.nextExecutionDate),
    ]);
    return statement.get().then((rows) => rows.map(_mapRow).toList());
  }

  Future<List<RecurringTransaction>> getDueRecurringTransactions(
    DateTime asOf,
  ) {
    final endOfDay = DateTime(
      asOf.year,
      asOf.month,
      asOf.day,
      23,
      59,
      59,
      999,
    );
    return (select(recurringTransactions)
          ..where((table) => table.isPaused.equals(false))
          ..where(
            (table) => table.nextExecutionDate.isSmallerOrEqualValue(endOfDay),
          )
          ..orderBy([(table) => OrderingTerm.asc(table.nextExecutionDate)]))
        .get();
  }

  Future<RecurringTransactionWithCategory?> getRecurringTransactionById(
    String id,
  ) async {
    final statement = _joinedQuery()
      ..where(recurringTransactions.id.equals(id));
    final row = await statement.getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> insertRecurringTransaction(
    RecurringTransactionsCompanion recurringTransaction,
  ) {
    return into(recurringTransactions).insert(recurringTransaction);
  }

  Future<bool> updateRecurringTransaction(
    RecurringTransactionsCompanion recurringTransaction,
  ) async {
    final updated = await (update(recurringTransactions)
          ..where((table) => table.id.equals(recurringTransaction.id.value)))
        .write(recurringTransaction);
    return updated > 0;
  }

  Future<bool> deleteRecurringTransaction(String id) async {
    final deleted = await (delete(recurringTransactions)
          ..where((table) => table.id.equals(id)))
        .go();
    return deleted > 0;
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joinedQuery() {
    return select(recurringTransactions).join([
      innerJoin(
        categories,
        categories.id.equalsExp(recurringTransactions.categoryId),
      ),
    ]);
  }

  void _applyFilters(
    JoinedSelectStatement<HasResultSet, dynamic> statement, {
    bool? isPaused,
    String? query,
  }) {
    if (isPaused != null) {
      statement.where(recurringTransactions.isPaused.equals(isPaused));
    }
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      statement.where(
        recurringTransactions.note.like('%$trimmedQuery%') |
            categories.name.like('%$trimmedQuery%'),
      );
    }
  }

  RecurringTransactionWithCategory _mapRow(TypedResult row) {
    return RecurringTransactionWithCategory(
      recurringTransaction: row.readTable(recurringTransactions),
      category: row.readTable(categories),
    );
  }
}
