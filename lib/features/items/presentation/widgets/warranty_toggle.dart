import 'package:flutter/material.dart';
import 'date_picker_field.dart';

class WarrantyToggle extends StatelessWidget {
  final bool hasExpiry;
  final ValueChanged<bool> onToggleChanged;
  final DateTime? expiryDate;
  final ValueChanged<DateTime> onExpiryDateSelected;
  final String? categoryName;

  const WarrantyToggle({
    super.key,
    required this.hasExpiry,
    required this.onToggleChanged,
    required this.expiryDate,
    required this.onExpiryDateSelected,
    this.categoryName,
  });

  bool get _isInsurance => categoryName == "Insurance";

  String get _dateLabel {
    if (_isInsurance) return "Renewal Date";
    if (categoryName == "Documents") return "Expiry Date";
    return "Warranty End Date"; // Electronics/Furniture/Books/Shoes + default
  }

  @override
  Widget build(BuildContext context) {
    if (_isInsurance) {
      return DatePickerField(
        label: _dateLabel,
        selectedDate: expiryDate,
        onDateSelected: onExpiryDateSelected,
        firstDate: DateTime.now(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Does this item have a warranty / renewal?",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _ToggleOption(
                label: "Yes",
                isSelected: hasExpiry,
                onTap: () => onToggleChanged(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ToggleOption(
                label: "No",
                isSelected: !hasExpiry,
                onTap: () => onToggleChanged(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (hasExpiry)
          DatePickerField(
            label: "Warranty End Date",
            selectedDate: expiryDate,
            onDateSelected: onExpiryDateSelected,
            firstDate: DateTime.now(), // expiry future mein hi honi chahiye
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "No warranty — this item won't get expiry reminders.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
