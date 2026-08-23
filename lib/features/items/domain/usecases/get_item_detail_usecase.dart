import '../../data/models/item_detail_model.dart';
import '../repositories/items_repository.dart';

class GetItemDetailUsecase {
  final ItemsRepository repository;
  GetItemDetailUsecase(this.repository);

  Future<ItemDetailModel> call(int itemId) {
    return repository.getItemDetail(itemId);
  }
}