import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemsFilter {
  final int? categoryId;
  final String search;

  const ItemsFilter({this.categoryId, this.search = ''});

  ItemsFilter copyWith({int? categoryId, String? search, bool clearCategory = false}) {
    return ItemsFilter(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      search: search ?? this.search,
    );
  }
}

class ItemsFilterNotifier extends Notifier<ItemsFilter> {
  @override
  ItemsFilter build() => const ItemsFilter();

  void setCategory(int? categoryId) {
    state = state.copyWith(categoryId: categoryId, clearCategory: categoryId == null);
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }
}

final itemsFilterProvider = NotifierProvider<ItemsFilterNotifier, ItemsFilter>(
  ItemsFilterNotifier.new,
);