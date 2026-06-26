import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_error_code.dart';
import '../../domain/entities/budget_params.dart';

@lazySingleton
class BudgetLocalDataSource {
  BudgetLocalDataSource(this._database);

  final db.AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Stream<List<Budget>> watchBudgets({String? query}) {
    return _database.budgetDao
        .watchBudgets(query: query)
        .map((rows) => rows.map(_mapRow).toList());
  }

  Future<List<Budget>> getBudgets({String? query}) async {
    final rows = await _database.budgetDao.getBudgets(query: query);
    return rows.map(_mapRow).toList();
  }

  Future<Budget?> getBudgetById(String id) async {
    final row = await _database.budgetDao.getBudgetById(id);
    return row == null ? null : _mapRow(row);
  }

  Future<Budget> createBudget(CreateBudgetParams params) async {
    _validateName(params.name);
    _validateAmount(params.amount);
    _validateDateRange(params.startDate, params.endDate);
    await _validateCategory(params.categoryId);

    final trimmedName = params.name.trim();
    final exists = await _database.budgetDao.budgetNameExists(name: trimmedName);
    if (exists) {
      throw const BudgetException(BudgetErrorCode.duplicateName);
    }

    final now = DateTime.now();
    final id = _uuid.v4();
    await _database.budgetDao.insertBudget(
      db.BudgetsCompanion.insert(
        id: id,
        name: trimmedName,
        amount: params.amount,
        startDate: params.startDate,
        endDate: params.endDate,
        categoryId: Value(params.categoryId),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final created = await getBudgetById(id);
    if (created == null) {
      throw const BudgetException(BudgetErrorCode.unknown);
    }
    return created;
  }

  Future<Budget> updateBudget(UpdateBudgetParams params) async {
    _validateName(params.name);
    _validateAmount(params.amount);
    _validateDateRange(params.startDate, params.endDate);
    await _validateCategory(params.categoryId);

    final existing = await getBudgetById(params.id);
    if (existing == null) {
      throw const BudgetException(BudgetErrorCode.budgetNotFound);
    }

    final trimmedName = params.name.trim();
    final exists = await _database.budgetDao.budgetNameExists(
      name: trimmedName,
      excludeId: params.id,
    );
    if (exists) {
      throw const BudgetException(BudgetErrorCode.duplicateName);
    }

    final updated = await _database.budgetDao.updateBudget(
      db.BudgetsCompanion(
        id: Value(params.id),
        name: Value(trimmedName),
        amount: Value(params.amount),
        startDate: Value(params.startDate),
        endDate: Value(params.endDate),
        categoryId: Value(params.categoryId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!updated) {
      throw const BudgetException(BudgetErrorCode.unknown);
    }

    final budget = await getBudgetById(params.id);
    if (budget == null) {
      throw const BudgetException(BudgetErrorCode.unknown);
    }
    return budget;
  }

  Future<void> deleteBudget(String id) async {
    final existing = await getBudgetById(id);
    if (existing == null) {
      throw const BudgetException(BudgetErrorCode.budgetNotFound);
    }

    final deleted = await _database.budgetDao.deleteBudget(id);
    if (!deleted) {
      throw const BudgetException(BudgetErrorCode.unknown);
    }
  }

  Future<BudgetUsage> getBudgetUsage(String budgetId) async {
    final budget = await getBudgetById(budgetId);
    if (budget == null) {
      throw const BudgetException(BudgetErrorCode.budgetNotFound);
    }

    final spentAmount = await _database.transactionDao.sumExpenses(
      startDate: budget.startDate,
      endDate: budget.endDate,
      categoryId: budget.categoryId,
    );

    String? categoryName;
    if (budget.categoryId != null) {
      final category =
          await _database.categoryDao.getCategoryById(budget.categoryId!);
      categoryName = category?.name;
    }

    final remainingAmount = budget.amount - spentAmount;
    final usagePercentage = budget.amount > 0
        ? (spentAmount / budget.amount) * 100.0
        : 0.0;

    return BudgetUsage(
      budget: budget,
      spentAmount: spentAmount,
      remainingAmount: remainingAmount,
      usagePercentage: usagePercentage,
      categoryName: categoryName,
    );
  }

  void _validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const BudgetException(BudgetErrorCode.nameRequired);
    }
    if (trimmed.length < 2) {
      throw const BudgetException(BudgetErrorCode.nameTooShort);
    }
  }

  void _validateAmount(double amount) {
    if (amount.isNaN || amount <= 0) {
      throw const BudgetException(BudgetErrorCode.amountInvalid);
    }
  }

  void _validateDateRange(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) {
      throw const BudgetException(BudgetErrorCode.dateRangeInvalid);
    }
  }

  Future<void> _validateCategory(String? categoryId) async {
    if (categoryId == null) {
      return;
    }

    if (categoryId.trim().isEmpty) {
      throw const BudgetException(BudgetErrorCode.categoryRequired);
    }

    final row = await _database.categoryDao.getCategoryById(categoryId);
    if (row == null) {
      throw const BudgetException(BudgetErrorCode.categoryNotFound);
    }

    if (row.type != 'expense') {
      throw const BudgetException(BudgetErrorCode.categoryTypeMismatch);
    }
  }

  Budget _mapRow(db.Budget row) {
    return Budget(
      id: row.id,
      name: row.name,
      amount: row.amount,
      startDate: row.startDate,
      endDate: row.endDate,
      categoryId: row.categoryId,
    );
  }
}
