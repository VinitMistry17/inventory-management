import 'dart:io';

import 'package:inventory_management/features/items/data/models/add_item_request_model.dart';
import 'package:inventory_management/features/items/data/models/category_model.dart';
import 'package:inventory_management/features/items/data/models/document_upload_response_model.dart';
import 'package:inventory_management/features/items/data/models/item_response_model.dart';
import 'package:inventory_management/features/items/data/models/photo_upload_response_model.dart';

abstract class ItemsRepository {
  Future<List<CategoryModel>> getCategories();
  Future<ItemResponseModel> createItem(AddItemRequestModel request);
  Future<PhotoUploadResponseModel> uploadPhotos(int itemId, List<File> photos);
  Future<DocumentUploadResponseModel> uploadDocument(int itemId, File document);
  Future<CategoryModel> createCategory(String name);
}