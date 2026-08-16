import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentPickerField extends StatelessWidget {
  final File? document;
  final ValueChanged<File?> onDocumentChanged;
  static const int maxSizeMb = 5;

  const DocumentPickerField({
    super.key,
    required this.document,
    required this.onDocumentChanged,
  });

  Future<void> _pickDocument(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result.isEmpty || result.first.path == null) return;

    final file = File(result.first.path!);
    final sizeMb = file.lengthSync() / (1024 * 1024);

    if (sizeMb > maxSizeMb) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File too large — max 5 MB allowed.")),
        );
      }
      return;
    }

    onDocumentChanged(file);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload document (PDF)",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        if (document == null)
          InkWell(
            onTap: () => _pickDocument(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(Icons.attach_file, color: colorScheme.primary),
                  const SizedBox(height: 6),
                  Text(
                    "Tap to attach a PDF",
                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "max 5 MB",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    document!.path.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                InkWell(
                  onTap: () => onDocumentChanged(null),
                  child: Icon(Icons.close, size: 18, color: colorScheme.error),
                ),
              ],
            ),
          ),
      ],
    );
  }
}