import '../repositories/items_repository.dart';

class DeleteItemUsecase {
  final ItemsRepository repository;
  DeleteItemUsecase(this.repository);

  Future<void> call(int itemId) {
    return repository.deleteItem(itemId);
  }
}