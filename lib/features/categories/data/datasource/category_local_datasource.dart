import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/constants/category_colors.dart';
import '../../domain/constants/category_icons.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/category_error_code.dart';
import '../../domain/entities/category_params.dart';

@lazySingleton
class CategoryLocalDataSource {
  CategoryLocalDataSource(this._database);

  final db.AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Stream<List<Category>> watchCategories({
    CategoryType? type,
    String? query,
  }) {
    return _database.categoryDao
        .watchCategories(
          type: _encodeType(type),
          query: query,
        )
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<Category>> getCategories({
    CategoryType? type,
    String? query,
  }) async {
    final rows = await _database.categoryDao.getCategories(
      type: _encodeType(type),
      query: query,
    );
    return rows.map(_mapRow).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final row = await _database.categoryDao.getCategoryById(id);
    return row == null ? null : _mapRow(row);
  }

  Future<Category> createCategory(CreateCategoryParams params) async {
    _validateName(params.name);
    final typeValue = _encodeType(params.type)!;
    final trimmedName = params.name.trim();

    final exists = await _database.categoryDao.categoryNameExists(
      name: trimmedName,
      type: typeValue,
    );
    if (exists) {
      throw const CategoryException(CategoryErrorCode.duplicateName);
    }

    final now = DateTime.now();
    final id = _uuid.v4();
    await _database.categoryDao.insertCategory(
      db.CategoriesCompanion.insert(
        id: id,
        name: trimmedName,
        type: typeValue,
        iconCode: params.iconCode,
        colorValue: params.colorValue,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final created = await getCategoryById(id);
    if (created == null) {
      throw const CategoryException(CategoryErrorCode.unknown);
    }
    return created;
  }

  Future<Category> updateCategory(UpdateCategoryParams params) async {
    _validateName(params.name);
    final existing = await getCategoryById(params.id);
    if (existing == null) {
      throw const CategoryException(CategoryErrorCode.categoryNotFound);
    }

    final typeValue = _encodeType(params.type)!;
    final trimmedName = params.name.trim();
    final exists = await _database.categoryDao.categoryNameExists(
      name: trimmedName,
      type: typeValue,
      excludeId: params.id,
    );
    if (exists) {
      throw const CategoryException(CategoryErrorCode.duplicateName);
    }

    final updated = await _database.categoryDao.updateCategory(
      db.CategoriesCompanion(
        id: Value(params.id),
        name: Value(trimmedName),
        type: Value(typeValue),
        iconCode: Value(params.iconCode),
        colorValue: Value(params.colorValue),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!updated) {
      throw const CategoryException(CategoryErrorCode.unknown);
    }

    final category = await getCategoryById(params.id);
    if (category == null) {
      throw const CategoryException(CategoryErrorCode.unknown);
    }
    return category;
  }

  Future<void> deleteCategory(String id) async {
    final existing = await getCategoryById(id);
    if (existing == null) {
      throw const CategoryException(CategoryErrorCode.categoryNotFound);
    }

    final transactionCount =
        await _database.categoryDao.countTransactionsForCategory(id);
    if (transactionCount > 0) {
      throw const CategoryException(CategoryErrorCode.hasTransactions);
    }

    final deleted = await _database.categoryDao.deleteCategory(id);
    if (!deleted) {
      throw const CategoryException(CategoryErrorCode.unknown);
    }
  }

  Future<bool> hasTransactions(String categoryId) async {
    final count =
        await _database.categoryDao.countTransactionsForCategory(categoryId);
    return count > 0;
  }

  void _validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const CategoryException(CategoryErrorCode.nameRequired);
    }
    if (trimmed.length < 2) {
      throw const CategoryException(CategoryErrorCode.nameTooShort);
    }
  }

  Category _mapRow(db.Category row) {
    return Category(
      id: row.id,
      name: row.name,
      type: _decodeType(row.type),
      iconCode: row.iconCode,
      colorValue: row.colorValue,
    );
  }

  String? _encodeType(CategoryType? type) {
    return switch (type) {
      CategoryType.income => 'income',
      CategoryType.expense => 'expense',
      null => null,
    };
  }

  CategoryType _decodeType(String value) {
    return switch (value) {
      'income' => CategoryType.income,
      _ => CategoryType.expense,
    };
  }

  static int defaultColorValue =
      CategoryColors.encode(CategoryColors.palette.first);

  static String defaultIconCode = CategoryIcons.defaultIconCode;
}
