import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/categories/data/datasource/category_local_datasource.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category_error_code.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';

class _TestAppDatabase extends AppDatabase {
  _TestAppDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late _TestAppDatabase database;
  late CategoryLocalDataSource dataSource;

  setUp(() async {
    database = _TestAppDatabase();
    dataSource = CategoryLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('createCategory stores and returns a category', () async {
    final category = await dataSource.createCategory(
      const CreateCategoryParams(
        name: 'Groceries',
        type: CategoryType.expense,
        iconCode: 'shopping_cart',
        colorValue: 0xFF1B6B4A,
      ),
    );

    expect(category.name, 'Groceries');
    expect(category.type, CategoryType.expense);
  });

  test('createCategory rejects duplicate names for the same type', () async {
    await dataSource.createCategory(
      const CreateCategoryParams(
        name: 'Salary',
        type: CategoryType.income,
        iconCode: 'payments',
        colorValue: 0xFF1B6B4A,
      ),
    );

    expect(
      () => dataSource.createCategory(
        const CreateCategoryParams(
          name: 'Salary',
          type: CategoryType.income,
          iconCode: 'work',
          colorValue: 0xFF1565C0,
        ),
      ),
      throwsA(
        isA<CategoryException>().having(
          (error) => error.code,
          'code',
          CategoryErrorCode.duplicateName,
        ),
      ),
    );
  });

  test('deleteCategory fails when transactions exist', () async {
    final category = await dataSource.createCategory(
      const CreateCategoryParams(
        name: 'Rent',
        type: CategoryType.expense,
        iconCode: 'home',
        colorValue: 0xFF1B6B4A,
      ),
    );

    await database.into(database.transactions).insert(
          TransactionsCompanion.insert(
            id: 'tx-1',
            categoryId: category.id,
            type: 'expense',
            amount: 1000,
            date: DateTime.now(),
          ),
        );

    expect(
      () => dataSource.deleteCategory(category.id),
      throwsA(
        isA<CategoryException>().having(
          (error) => error.code,
          'code',
          CategoryErrorCode.hasTransactions,
        ),
      ),
    );
  });
}
