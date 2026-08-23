import '../../data/models/item_list_item_model.dart';
import '../repositories/items_repository.dart';

class GetItemsUsecase {
  final ItemsRepository repository;
  GetItemsUsecase(this.repository);

  Future<List<ItemListItemModel>> call({int? categoryId, String? search}) {
    return repository.getItems(categoryId: categoryId, search: search);
  }
}