import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/categories_provider.dart';

class CategoryFilterDropdown extends ConsumerWidget {
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;

  const CategoryFilterDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        return DropdownButtonFormField<int?>(
          initialValue: selectedCategoryId,
          decoration: const InputDecoration(
            labelText: "Category",
            isDense: true,
          ),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text("All Categories")),
            ...categories.map((category) {
              return DropdownMenuItem<int?>(
                value: category.id,
                child: Text(category.name),
              );
            }),
          ],
          onChanged: onChanged,
        );
      },
      loading: () => const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => const Text("Failed to load categories"),
    );
  }
}