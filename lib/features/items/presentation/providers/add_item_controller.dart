import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/features/items/data/models/item_response_model.dart';
import 'package:inventory_management/features/alerts/presentation/providers/alerts_providers.dart';
import 'package:inventory_management/features/home/presentation/providers/home_providers.dart';
import '../../data/models/add_item_request_model.dart';
import 'items_providers.dart';
import 'items_provider.dart';
import 'add_item_result.dart';
import 'item_detail_provider.dart';

class AddItemController extends AsyncNotifier<AddItemResult?> {
  @override
  FutureOr<AddItemResult?> build() {
    return null;
  }

  Future<void> saveItem({
    int? itemId, // 👈 naya — null = create, non-null = update
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
      final request = AddItemRequestModel(
        name: name,
        categoryId: categoryId,
        purchaseDate: purchaseDate,
        hasExpiry: hasExpiry,
        expiryDate: expiryDate,
        pricePaid: pricePaid,
        location: location,
      );

      if (itemId != null) {
        // ---- UPDATE MODE ----
        final updateUsecase = ref.read(updateItemUsecaseProvider);
        await updateUsecase(itemId, request);

        // photos/document bhi update ho sakte hain, agar naye select kiye ho
        String? warning;
        if (photos.isNotEmpty) {
          try {
            final uploadPhotosUsecase = ref.read(uploadPhotosUsecaseProvider);
            await uploadPhotosUsecase(itemId, photos);
          } catch (e) {
            warning = "Item updated, but photo upload failed.";
          }
        }
        if (document != null) {
          try {
            final uploadDocumentUsecase = ref.read(
              uploadDocumentUsecaseProvider,
            );
            await uploadDocumentUsecase(itemId, document);
          } catch (e) {
            warning = warning == null
                ? "Item updated, but document upload failed."
                : "Item updated, but photo and document upload failed.";
          }
        }

        // Fresh data ke liye Item Detail provider invalidate karo (Option A pattern)
        ref.invalidate(itemDetailProvider(itemId));

        // Create mode jaisa hi result shape chahiye UI ke liye — ab humein GET se fresh item chahiye
        final getItemDetailUsecase = ref.read(getItemDetailUsecaseProvider);
        final freshItem = await getItemDetailUsecase(itemId);

        state = AsyncValue.data(
          AddItemResult(
            item: ItemResponseModel(
              id: freshItem.id,
              name: freshItem.name,
              categoryId: freshItem.categoryId,
              purchaseDate: freshItem.purchaseDate,
              hasExpiry: freshItem.hasExpiry,
              expiryDate: freshItem.expiryDate,
              pricePaid: freshItem.pricePaid,
              location: freshItem.location,
              qrCode: freshItem.qrCode,
            ),
            warning: warning,
          ),
        );
        _invalidateItemLists();
      } else {
        // ---- CREATE MODE (jaisa pehle tha) ----
        final createItemUsecase = ref.read(createItemUsecaseProvider);
        final item = await createItemUsecase(request);

        String? warning;
        if (photos.isNotEmpty) {
          try {
            final uploadPhotosUsecase = ref.read(uploadPhotosUsecaseProvider);
            await uploadPhotosUsecase(item.id, photos);
          } catch (e) {
            warning = "Item saved, but photo upload failed.";
          }
        }
        if (document != null) {
          try {
            final uploadDocumentUsecase = ref.read(
              uploadDocumentUsecaseProvider,
            );
            await uploadDocumentUsecase(item.id, document);
          } catch (e) {
            warning = warning == null
                ? "Item saved, but document upload failed."
                : "Item saved, but photo and document upload failed.";
          }
        }

        state = AsyncValue.data(AddItemResult(item: item, warning: warning));
        _invalidateItemLists();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void _invalidateItemLists() {
    ref.invalidate(dashboardProvider);
    ref.invalidate(itemsProvider);
    ref.invalidate(alertsProvider);
  }
}

final addItemControllerProvider =
    AsyncNotifierProvider<AddItemController, AddItemResult?>(
      AddItemController.new,
    );
