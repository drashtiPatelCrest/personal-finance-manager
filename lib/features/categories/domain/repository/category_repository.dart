import '../entities/category.dart';
import '../entities/category_params.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories({CategoryType? type, String? query});

  Future<Category?> getCategoryById(String id);

  Future<Category> createCategory(CreateCategoryParams params);

  Future<Category> updateCategory(UpdateCategoryParams params);

  Future<void> deleteCategory(String id);

  Future<bool> hasTransactions(String categoryId);

  Stream<List<Category>> watchCategories({
    CategoryType? type,
    String? query,
  });
}
