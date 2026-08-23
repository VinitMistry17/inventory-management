import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/items/presentation/providers/categories_provider.dart';
import 'package:inventory_management/features/items/presentation/widgets/item_card.dart';
import 'package:inventory_management/features/items/presentation/screens/item_detail_screen.dart';
import 'package:inventory_management/features/items/utils/category_icons.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onNavigateToAlerts;
  final ValueChanged<int> onNavigateToItemsWithCategory;

  const HomeScreen({
    super.key,
    required this.onNavigateToAlerts,
    required this.onNavigateToItemsWithCategory,
  });

  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(dashboardProvider.future),
      ref.refresh(categoriesProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return dashboardAsync.when(
      data: (dashboard) {
        return RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${dashboard.totalItems} items tracked",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                if (dashboard.topAlert != null)
                  _AlertBanner(
                    name: dashboard.topAlert!.name,
                    daysLeft: dashboard.topAlert!.daysLeft,
                    onTap: onNavigateToAlerts,
                  ),

                const SizedBox(height: 20),

                Text(
                  "Categories",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                categoriesAsync.when(
                  data: (categories) => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _CategoryTile(
                        name: category.name,
                        icon: getCategoryIcon(category.icon),
                        onTap: () => onNavigateToItemsWithCategory(category.id),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      const Text("Failed to load categories"),
                ),

                const SizedBox(height: 20),

                Text(
                  "Recently Added",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (dashboard.recentItems.isEmpty)
                  const Text("No items yet")
                else
                  categoriesAsync.when(
                    data: (categories) {
                      final categoryNames = {
                        for (var c in categories) c.id: c.name,
                      };

                      return Column(
                        children: dashboard.recentItems.map((item) {
                          return ItemCard(
                            name: item.name,
                            categoryName:
                                categoryNames[item.categoryId] ?? "Unknown",
                            hasExpiry: item.expiryDate != null,
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
                        }).toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        const Text("Failed to load categories"),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        final message = err is AppException
            ? err.message
            : "Failed to load dashboard";
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(dashboardProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String name;
  final int daysLeft;
  final VoidCallback onTap;

  const _AlertBanner({
    required this.name,
    required this.daysLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "$name expires in $daysLeft days",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
