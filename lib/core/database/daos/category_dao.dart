import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';
import '../tables/transactions_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories, Transactions])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Stream<List<Category>> watchCategories({
    String? type,
    String? query,
  }) {
    final statement = select(categories);
    _applyFilters(statement, type: type, query: query);
    statement.orderBy([(table) => OrderingTerm.asc(table.name)]);
    return statement.watch();
  }

  Future<List<Category>> getCategories({
    String? type,
    String? query,
  }) {
    final statement = select(categories);
    _applyFilters(statement, type: type, query: query);
    statement.orderBy([(table) => OrderingTerm.asc(table.name)]);
    return statement.get();
  }

  Future<Category?> getCategoryById(String id) {
    return (select(categories)..where((table) => table.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  Future<bool> updateCategory(CategoriesCompanion category) async {
    final updated = await (update(categories)
          ..where((table) => table.id.equals(category.id.value)))
        .write(category);
    return updated > 0;
  }

  Future<bool> deleteCategory(String id) async {
    final deleted =
        await (delete(categories)..where((table) => table.id.equals(id))).go();
    return deleted > 0;
  }

  Future<int> countTransactionsForCategory(String categoryId) async {
    final countExp = transactions.id.count();
    final query = selectOnly(transactions)
      ..addColumns([countExp])
      ..where(transactions.categoryId.equals(categoryId));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<bool> categoryNameExists({
    required String name,
    required String type,
    String? excludeId,
  }) async {
    final results = await (select(categories)
          ..where(
            (table) => table.name.equals(name) & table.type.equals(type),
          ))
        .get();
    if (excludeId == null) {
      return results.isNotEmpty;
    }
    return results.any((category) => category.id != excludeId);
  }

  void _applyFilters(
    SimpleSelectStatement<$CategoriesTable, Category> statement, {
    String? type,
    String? query,
  }) {
    if (type != null) {
      statement.where((table) => table.type.equals(type));
    }
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      statement.where((table) => table.name.like('%$trimmedQuery%'));
    }
  }
}
