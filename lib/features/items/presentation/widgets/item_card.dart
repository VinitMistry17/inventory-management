import 'package:flutter/material.dart';
import '../../utils/expiry_status.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String categoryName;
  final bool hasExpiry;
  final String? expiryDate;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.name,
    required this.categoryName,
    required this.hasExpiry,
    this.expiryDate,
    required this.onTap,
  });

  Color _badgeColor(ExpiryStatus status, ColorScheme colorScheme) {
    switch (status) {
      case ExpiryStatus.expired:
        return colorScheme.error;
      case ExpiryStatus.warning:
        return const Color(0xFFF59E0B);
      case ExpiryStatus.ok:
        return colorScheme.primary;
      case ExpiryStatus.none:
        return colorScheme.outlineVariant;
    }
  }

  String _badgeText(ExpiryStatus status, String? expiryDate) {
    if (status == ExpiryStatus.none) return "No expiry";
    final expiry = DateTime.parse(expiryDate!);
    final daysLeft = expiry.difference(DateTime.now()).inDays;
    if (status == ExpiryStatus.expired) return "Expired";
    return "$daysLeft days left";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = getExpiryStatus(hasExpiry, expiryDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(categoryName, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _badgeColor(status, colorScheme).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _badgeText(status, expiryDate),
                  style: TextStyle(color: _badgeColor(status, colorScheme), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}