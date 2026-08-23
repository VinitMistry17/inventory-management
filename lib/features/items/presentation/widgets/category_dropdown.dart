import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/categories_provider.dart';
import '../providers/create_category_controller.dart';

const int _addNewCategoryValue = -1; // special sentinel value dropdown ke liye

class CategoryDropdown extends ConsumerWidget {
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;
  final ValueChanged<String?>? onCategoryNameChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
    this.onCategoryNameChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        return DropdownButtonFormField<int>(
          initialValue: selectedCategoryId,
          decoration: const InputDecoration(
            labelText: "Category",
          ),
          items: [
            ...categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name),
              );
            }),
            DropdownMenuItem<int>(
              value: _addNewCategoryValue,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    "Add New Category",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (value) async {
            if (value == _addNewCategoryValue) {
              await _showAddCategoryDialog(context, ref);
            } else {
              onChanged(value);
              final selected = categories.where((c) => c.id == value).firstOrNull;
              onCategoryNameChanged?.call(selected?.name);
            }
          },
          validator: (value) => value == null ? "Please select a category" : null,
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Row(
        children: [
          Expanded(
            child: Text(
              "Failed to load categories",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(categoriesProvider),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context, WidgetRef ref) async {
    ref.read(createCategoryControllerProvider.notifier).reset();
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, ref, _) {
            final createState = ref.watch(createCategoryControllerProvider);

            // Success hote hi dialog band karo, list refresh karo, naya category select karo
            ref.listen(createCategoryControllerProvider, (previous, next) {
              next.whenOrNull(
                data: (category) {
                  if (category != null) {
                    ref.invalidate(categoriesProvider);
                    onChanged(category.id);
                    Navigator.of(dialogContext).pop();
                  }
                },
              );
            });

            final isLoading = createState.isLoading;
            final errorMessage = createState.hasError ? createState.error.toString() : null;

            return AlertDialog(   
              title: const Text("Add New Category"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "e.g. Jewellery",
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final name = nameController.text.trim();
                          if (name.isNotEmpty) {
                            ref.read(createCategoryControllerProvider.notifier).create(name);
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}