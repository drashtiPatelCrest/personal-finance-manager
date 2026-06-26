import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category_error_code.dart';
import 'package:personal_finance_manager/features/categories/domain/entities/category_params.dart';

void main() {
  group('CreateCategoryParams', () {
    test('supports value equality', () {
      const first = CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF000000,
      );
      const second = CreateCategoryParams(
        name: 'Food',
        type: CategoryType.expense,
        iconCode: 'restaurant',
        colorValue: 0xFF000000,
      );

      expect(first, equals(second));
    });
  });

  group('CategoryErrorCode', () {
    test('contains deletion guard error', () {
      expect(
        CategoryErrorCode.values,
        contains(CategoryErrorCode.hasTransactions),
      );
    });
  });
}
