import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/item_detail_model.dart';
import 'items_providers.dart';

final itemDetailProvider = FutureProvider.family<ItemDetailModel, int>((ref, itemId) async {
  final usecase = ref.watch(getItemDetailUsecaseProvider);
  return usecase(itemId);
});