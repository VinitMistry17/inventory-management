import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/features/items/data/models/item_detail_model.dart';
import 'package:inventory_management/features/items/presentation/providers/delete_item_controller.dart';
import 'package:inventory_management/features/items/presentation/screens/add_item_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/item_detail_provider.dart';

class ItemDetailScreen extends ConsumerWidget {
  final int itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  String _formatDate(String rawDate) {
    final date = DateTime.parse(rawDate);
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _expiryLabel(String categoryName) {
    if (categoryName == "Insurance") return "Renewal Date";
    if (categoryName == "Documents") return "Expiry Date";
    return "Warranty End Date";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailProvider(itemId));

    // Delete ka result listen karo
    ref.listen(deleteItemControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          // sirf tabhi trigger ho jab loading se success mein transition hua ho (initial build pe nahi)
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Item deleted")));
            Navigator.pop(context);
          }
        },
        error: (err, stack) {
          final message = err is AppException
              ? err.message
              : "Failed to delete item";
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    final isDeleting = ref.watch(deleteItemControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      body: itemAsync.when(
        data: (item) => _ItemDetailBody(
          item: item,
          formatDate: _formatDate,
          expiryLabel: _expiryLabel,
          onDeleteTap: isDeleting
              ? null
              : () => _confirmDelete(context, ref, itemId),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          final message = err is AppException
              ? err.message
              : "Failed to load item";
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.invalidate(itemDetailProvider(itemId)),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ItemDetailBody extends StatelessWidget {
  final ItemDetailModel item;
  final String Function(String) formatDate;
  final String Function(String) expiryLabel;
  final VoidCallback? onDeleteTap;

  const _ItemDetailBody({
    required this.item,
    required this.formatDate,
    required this.expiryLabel,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo carousel (ya placeholder agar koi photo nahi)
          if (item.photos.isNotEmpty)
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: item.photos.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.photos[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stack) => const Center(
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

          const SizedBox(height: 24),

          Text(
            item.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            item.categoryName,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 20),

          _DetailRow(
            label: "Purchase Date",
            value: formatDate(item.purchaseDate),
          ),
          if (item.hasExpiry && item.expiryDate != null)
            _DetailRow(
              label: expiryLabel(item.categoryName),
              value: formatDate(item.expiryDate!),
            ),
          _DetailRow(label: "Price Paid", value: "₹${item.pricePaid}"),
          _DetailRow(label: "Location", value: item.location),

          if (item.documentUrl != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () =>
                  _openDocument(context, item.documentUrl!), // 👈 update
              child: Row(
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "View attached document",
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),

          // QR Code block — on-device generate
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // QR ko hamesha white background chahiye scan-ability ke liye
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: QrImageView(data: item.qrCode, size: 160),
                ),
                const SizedBox(height: 8),
                Text(
                  "Scan to identify this item",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddItemScreen(existingItem: item),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text("Edit"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDeleteTap,
                  icon: Icon(Icons.delete_outline, color: colorScheme.error),
                  label: Text(
                    "Delete",
                    style: TextStyle(color: colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

Future<void> _openDocument(BuildContext context, String url) async {
  print('DEBUG: trying to open -> $url');
  final uri = Uri.parse(url);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

  if (!launched && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Couldn't open document.")));
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  int itemId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Delete Item?"),
      content: const Text("This action cannot be undone."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            "Delete",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    await ref.read(deleteItemControllerProvider.notifier).delete(itemId);
  }
}
