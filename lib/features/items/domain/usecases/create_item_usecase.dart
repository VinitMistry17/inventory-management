import '../../data/models/add_item_request_model.dart';
import '../../data/models/item_response_model.dart';
import '../repositories/items_repository.dart';

class CreateItemUsecase {
  final ItemsRepository repository;
  CreateItemUsecase(this.repository);

  Future<ItemResponseModel> call(AddItemRequestModel request) {
    return repository.createItem(request);
  }
}