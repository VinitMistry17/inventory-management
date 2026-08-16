import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/add_item_request_model.dart';
import 'items_providers.dart';
import 'add_item_result.dart';

class AddItemController extends AsyncNotifier<AddItemResult?> {
  @override
  FutureOr<AddItemResult?> build() {
    return null;
  }

  Future<void> saveItem({
    required String name,
    required int categoryId,
    required String purchaseDate,
    required bool hasExpiry,
    String? expiryDate,
    required double pricePaid,
    required String location,
    required List<File> photos,
    File? document,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Step 1: Item create karo — ye fail hua toh poora operation fail
      final request = AddItemRequestModel(
        name: name,
        categoryId: categoryId,
        purchaseDate: purchaseDate,
        hasExpiry: hasExpiry,
        expiryDate: expiryDate,
        pricePaid: pricePaid,
        location: location,
      );

      final createItemUsecase = ref.read(createItemUsecaseProvider);
      final item = await createItemUsecase(request);

      // Item ban chuka hai — ab isse aage kuch bhi fail ho, item safe hai
      String? warning;

      // Step 2: Photos (agar hain)
      if (photos.isNotEmpty) {
        print('DEBUG: uploading ${photos.length} photos for item ${item.id}');
        try {
          final uploadPhotosUsecase = ref.read(uploadPhotosUsecaseProvider);
          final result = await uploadPhotosUsecase(item.id, photos);
          print('DEBUG: photo upload success: ${result.photos}');
        } catch (e) {
          print('DEBUG: photo upload FAILED: $e');
          warning = "Item saved, but photo upload failed.";
        }
      } else {
        print('DEBUG: no photos to upload (list was empty)');
      }

      // Step 3: Document (agar hai)
      if (document != null) {
        try {
          final uploadDocumentUsecase = ref.read(uploadDocumentUsecaseProvider);
          await uploadDocumentUsecase(item.id, document);
        } catch (e) {
          // agar photo ka warning already hai, dono ko combine karo
          warning = warning == null
              ? "Item saved, but document upload failed."
              : "Item saved, but photo and document upload failed.";
        }
      }

      state = AsyncValue.data(AddItemResult(item: item, warning: warning));
    } catch (e, stack) {
      // Ye sirf step 1 (createItem) fail hone pe aayega
      state = AsyncValue.error(e, stack);
    }
  }
}

final addItemControllerProvider =
    AsyncNotifierProvider<AddItemController, AddItemResult?>(
      AddItemController.new,
    );
