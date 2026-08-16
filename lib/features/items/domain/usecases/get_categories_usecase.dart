import '../../data/models/category_model.dart';
import '../repositories/items_repository.dart';

class GetCategoriesUsecase {
  final ItemsRepository repository;
  GetCategoriesUsecase(this.repository);

  Future<List<CategoryModel>> call() {
    return repository.getCategories();
  }
}