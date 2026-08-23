import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/item_list_item_model.dart';
import 'items_providers.dart';
import 'items_filter_provider.dart';

final itemsProvider = FutureProvider<List<ItemListItemModel>>((ref) async {
  final filter = ref.watch(itemsFilterProvider);
  final usecase = ref.watch(getItemsUsecaseProvider);

  return usecase(categoryId: filter.categoryId, search: filter.search);
});