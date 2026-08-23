import '../../data/models/add_item_request_model.dart';
import '../repositories/items_repository.dart';

class UpdateItemUsecase {
  final ItemsRepository repository;
  UpdateItemUsecase(this.repository);

  Future<void> call(int itemId, AddItemRequestModel request) {
    return repository.updateItem(itemId, request);
  }
}