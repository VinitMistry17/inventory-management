import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/items/presentation/providers/categories_provider.dart';
import 'package:inventory_management/features/items/presentation/screens/item_detail_screen.dart';
import '../providers/alerts_providers.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref.refresh(alertsProvider.future),
      ref.refresh(categoriesProvider.future),
    ]);
  }

  Color _statusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case "expired":
        return colorScheme.error;
      case "warning":
        return const Color(0xFFF59E0B);
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return alertsAsync.when(
      data: (alerts) {
        if (alerts.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(
                  height: 400,
                  child: Center(
                    child: Text("Nothing needs attention right now"),
                  ),
                ),
              ],
            ),
          );
        }

        return categoriesAsync.when(
          data: (categories) {
            final categoryNames = {for (var c in categories) c.id: c.name};

            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  final color = _statusColor(alert.status, colorScheme);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemDetailScreen(itemId: alert.itemId),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.15),
                        child: Text(
                          "${alert.daysLeft}",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      title: Text(alert.name),
                      subtitle: Text(
                        categoryNames[alert.categoryId] ?? "Unknown",
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              const Center(child: Text("Failed to load categories")),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        final message = err is AppException
            ? err.message
            : "Failed to load alerts";
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(alertsProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      },
    );
  }
}
