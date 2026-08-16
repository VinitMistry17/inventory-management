import 'dart:io';

import 'package:inventory_management/features/items/data/datasources/items_remote_datasource.dart';
import 'package:inventory_management/features/items/data/models/add_item_request_model.dart';
import 'package:inventory_management/features/items/data/models/category_model.dart';
import 'package:inventory_management/features/items/data/models/document_upload_response_model.dart';
import 'package:inventory_management/features/items/data/models/item_response_model.dart';
import 'package:inventory_management/features/items/data/models/photo_upload_response_model.dart';
import 'package:inventory_management/features/items/domain/repositories/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDatasource remoteDatasource;
  ItemsRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<CategoryModel>> getCategories() {
    return remoteDatasource.getCategories();
  }

  @override
  Future<ItemResponseModel> createItem(AddItemRequestModel request) {
    return remoteDatasource.createItem(request);
  }

  @override
  Future<PhotoUploadResponseModel> uploadPhotos(int itemId, List<File> photos) {
    return remoteDatasource.uploadPhotos(itemId, photos);
  }

  @override
  Future<DocumentUploadResponseModel> uploadDocument(
    int itemId,
    File document,
  ) {
    return remoteDatasource.uploadDocument(itemId, document);
  }

  @override
  Future<CategoryModel> createCategory(String name) {
    return remoteDatasource.createCategory(name);
  }
}
