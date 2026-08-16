import '../../data/models/category_model.dart';
import '../repositories/items_repository.dart';

class CreateCategoryUsecase {
  final ItemsRepository repository;
  CreateCategoryUsecase(this.repository);

  Future<CategoryModel> call(String name) {
    return repository.createCategory(name);
  }
}