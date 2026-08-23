import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/items/presentation/providers/items_filter_provider.dart';
import 'package:inventory_management/features/items/presentation/providers/items_provider.dart';
import 'package:inventory_management/features/items/presentation/providers/categories_provider.dart';
import 'package:inventory_management/features/items/presentation/screens/item_detail_screen.dart';
import '../widgets/category_filter_dropdown.dart';
import '../widgets/item_card.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel(); // purana pending timer cancel karo
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      ref.read(itemsFilterProvider.notifier).setSearch(value);
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.refresh(itemsProvider.future),
      ref.refresh(categoriesProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsProvider);
    final filter = ref.watch(itemsFilterProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              hintText: "Search items...",
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),

          CategoryFilterDropdown(
            selectedCategoryId: filter.categoryId,
            onChanged: (categoryId) =>
                ref.read(itemsFilterProvider.notifier).setCategory(categoryId),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: itemsAsync.when(
              data: (items) {
                print(
                  'DEBUG ITEMS SCREEN -> items data: ${items.length} items',
                );
                if (items.isEmpty) {
                  print('DEBUG ITEMS SCREEN -> rendering empty state');
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 400,
                          child: Center(child: Text("No items found")),
                        ),
                      ],
                    ),
                  );
                }

                return categoriesAsync.when(
                  data: (categories) {
                    print(
                      'DEBUG ITEMS SCREEN -> categories data: ${categories.length} categories, rendering ${items.length} items',
                    );
                    // id -> name lookup map banaya, taaki har card ke liye baar-baar search na karna pade
                    final categoryNames = {
                      for (var c in categories) c.id: c.name,
                    };

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ItemCard(
                            name: item.name,
                            categoryName:
                                categoryNames[item.categoryId] ?? "Unknown",
                            hasExpiry: item.hasExpiry,
                            expiryDate: item.expiryDate,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetailScreen(itemId: item.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  loading: () {
                    print('DEBUG ITEMS SCREEN -> categories loading');
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (err, stack) {
                    print('DEBUG ITEMS SCREEN -> categories error: $err');
                    print(stack);
                    return const Text("Failed to load categories");
                  },
                );
              },
              loading: () {
                print('DEBUG ITEMS SCREEN -> items loading');
                return const Center(child: CircularProgressIndicator());
              },
              error: (err, stack) {
                print('DEBUG ITEMS SCREEN -> items error: $err');
                print(stack);
                final message = err is AppException
                    ? err.message
                    : "Failed to load items";
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => ref.invalidate(itemsProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
