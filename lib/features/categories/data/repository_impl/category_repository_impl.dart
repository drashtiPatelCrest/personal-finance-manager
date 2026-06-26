import 'package:injectable/injectable.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/category_params.dart';
import '../../domain/repository/category_repository.dart';
import '../datasource/category_local_datasource.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._localDataSource);

  final CategoryLocalDataSource _localDataSource;

  @override
  Future<List<Category>> getCategories({CategoryType? type, String? query}) {
    return _localDataSource.getCategories(type: type, query: query);
  }

  @override
  Future<Category?> getCategoryById(String id) {
    return _localDataSource.getCategoryById(id);
  }

  @override
  Future<Category> createCategory(CreateCategoryParams params) {
    return _localDataSource.createCategory(params);
  }

  @override
  Future<Category> updateCategory(UpdateCategoryParams params) {
    return _localDataSource.updateCategory(params);
  }

  @override
  Future<void> deleteCategory(String id) {
    return _localDataSource.deleteCategory(id);
  }

  @override
  Future<bool> hasTransactions(String categoryId) {
    return _localDataSource.hasTransactions(categoryId);
  }

  @override
  Stream<List<Category>> watchCategories({CategoryType? type, String? query}) {
    return _localDataSource.watchCategories(type: type, query: query);
  }
}
