import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../entities/category_params.dart';
import '../repository/category_repository.dart';

@injectable
class WatchCategoriesUseCase
    implements UseCase<Stream<List<Category>>, WatchCategoriesParams> {
  WatchCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Stream<List<Category>>> call(WatchCategoriesParams params) async {
    return _repository.watchCategories(
      type: params.type,
      query: params.query,
    );
  }
}

@injectable
class GetCategoriesUseCase
    implements UseCase<List<Category>, GetCategoriesParams> {
  GetCategoriesUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<List<Category>> call(GetCategoriesParams params) {
    return _repository.getCategories(type: params.type, query: params.query);
  }
}

@injectable
class GetCategoryByIdUseCase
    implements UseCase<Category?, GetCategoryByIdParams> {
  GetCategoryByIdUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Category?> call(GetCategoryByIdParams params) {
    return _repository.getCategoryById(params.id);
  }
}

@injectable
class CreateCategoryUseCase implements UseCase<Category, CreateCategoryParams> {
  CreateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Category> call(CreateCategoryParams params) {
    return _repository.createCategory(params);
  }
}

@injectable
class UpdateCategoryUseCase implements UseCase<Category, UpdateCategoryParams> {
  UpdateCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<Category> call(UpdateCategoryParams params) {
    return _repository.updateCategory(params);
  }
}

@injectable
class DeleteCategoryUseCase implements UseCase<void, DeleteCategoryParams> {
  DeleteCategoryUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<void> call(DeleteCategoryParams params) {
    return _repository.deleteCategory(params.id);
  }
}
