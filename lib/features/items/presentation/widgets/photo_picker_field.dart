import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerField extends StatelessWidget {
  final List<File> photos;
  final ValueChanged<List<File>> onPhotosChanged;
  static const int maxPhotos = 5;

  const PhotoPickerField({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
  });

  Future<void> _pickPhotos(BuildContext context) async {
    final remainingSlots = maxPhotos - photos.length;

    if (remainingSlots <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can add up to 5 photos only.")),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 80);

    if (pickedFiles.isEmpty) return;

    final newFiles = pickedFiles.take(remainingSlots).map((x) => File(x.path)).toList();

    if (pickedFiles.length > remainingSlots) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Only $remainingSlots more photo(s) could be added (max 5).")),
      );
    }

    onPhotosChanged([...photos, ...newFiles]);
  }

  void _removePhoto(int index) {
    final updated = [...photos]..removeAt(index);
    onPhotosChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photos",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        InkWell(
          onTap: () => _pickPhotos(context),
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
                Icon(Icons.add_a_photo_outlined, color: colorScheme.primary),
                const SizedBox(height: 6),
                Text(
                  "Tap to add photos",
                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  "uploads to Cloudinary · max 2 MB each",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        if (photos.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        photos[index],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: InkWell(
                        onTap: () => _removePhoto(index),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: colorScheme.error,
                          child: Icon(Icons.close, size: 14, color: colorScheme.onError),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}