import '../../data/models/item_response_model.dart';

class AddItemResult {
  final ItemResponseModel item;
  final String? warning; // null agar sab kuch sahi gaya

  AddItemResult({required this.item, this.warning});
}