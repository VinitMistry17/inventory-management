import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/core/constants/api_urls.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/core/network/api_headers.dart';
import 'package:inventory_management/features/items/data/models/add_item_request_model.dart';
import 'package:inventory_management/features/items/data/models/category_model.dart';
import 'package:inventory_management/features/items/data/models/document_upload_response_model.dart';
import 'package:inventory_management/features/items/data/models/item_detail_model.dart';
import 'package:inventory_management/features/items/data/models/item_list_item_model.dart';
import 'package:inventory_management/features/items/data/models/item_response_model.dart';
import 'package:inventory_management/features/items/data/models/photo_upload_response_model.dart';

class ItemsRemoteDatasource {
  final Ref ref;
  ItemsRemoteDatasource(this.ref);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final header = await getAuthHeaders(ref);

      final response = await http.get(
        Uri.parse(ApiUrls.categoriesUrl),
        headers: header,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final categories = (data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        return categories;
      } else {
        throw AppException(
          message: data['message'] ?? 'Failed to load categories',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<ItemResponseModel> createItem(AddItemRequestModel request) async {
    try {
      final header = await getAuthHeaders(ref);

      print('DEBUG SAVE ITEM -> request body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        Uri.parse(ApiUrls.itemsUrl),
        headers: header,
        body: jsonEncode(request.toJson()),
      );

      print('DEBUG SAVE ITEM -> statusCode: ${response.statusCode}');
      print('DEBUG SAVE ITEM -> body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('DEBUG SAVE ITEM -> parsed response: $data');
        return ItemResponseModel.fromJson(data);
      } else {
        print(
          'DEBUG SAVE ITEM -> error message: ${data['message'] ?? 'Failed to create item'}',
        );
        throw AppException(message: data['message'] ?? 'Failed to create item');
      }
    } on AppException {
      print('DEBUG SAVE ITEM -> AppException: $this');
      rethrow;
    } catch (e) {
      print('DEBUG SAVE ITEM -> catch error: $e');
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<PhotoUploadResponseModel> uploadPhotos(
    int itemId,
    List<File> photos,
  ) async {
    try {
      final headers = await getAuthHeadersMultipart(ref);
      final url = Uri.parse("${ApiUrls.itemsUrl}/$itemId/photos");

      final request = http.MultipartRequest("POST", url);
      request.headers.addAll(headers);

      for (final photo in photos) {
        request.files.add(
          await http.MultipartFile.fromPath("photos[]", photo.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(
        'DEBUG: photo upload statusCode -> ${response.statusCode}',
      ); // 👈 add karo
      print('DEBUG: photo upload raw body -> ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhotoUploadResponseModel.fromJson(data);
      } else {
        throw AppException(
          message: data['message'] ?? 'Failed to upload photos',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      print('DEBUG: actual upload exception -> $e');
      throw AppException(message: 'Network error while uploading photos.');
    }
  }

  Future<DocumentUploadResponseModel> uploadDocument(
    int itemId,
    File document,
  ) async {
    try {
      final headers = await getAuthHeadersMultipart(ref);
      final url = Uri.parse("${ApiUrls.itemsUrl}/$itemId/document");

      final request = http.MultipartRequest("POST", url);
      request.headers.addAll(headers);

      request.files.add(
        await http.MultipartFile.fromPath("document", document.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(
        'DEBUG: Document upload statusCode -> ${response.statusCode}',
      ); // 👈 add karo
      print('DEBUG: Document upload raw body -> ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DocumentUploadResponseModel.fromJson(data);
      } else {
        throw AppException(
          message: data['message'] ?? 'Failed to upload document',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error while uploading document.');
    }
  }

  Future<CategoryModel> createCategory(String name) async {
    try {
      final headers = await getAuthHeaders(ref);

      final response = await http.post(
        Uri.parse(ApiUrls.categoriesUrl),
        headers: headers,
        body: jsonEncode({"name": name}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return CategoryModel.fromJson(data);
      } else {
        throw AppException(
          message: data['message'] ?? 'Failed to create category',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<ItemDetailModel> getItemDetail(int itemId) async {
    try {
      final headers = await getAuthHeaders(ref);
      final url = Uri.parse("${ApiUrls.itemsUrl}/$itemId");

      final response = await http.get(url, headers: headers);
      print('DEBUG ITEM DETAIL -> statusCode: ${response.statusCode}');
      print('DEBUG ITEM DETAIL -> body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ItemDetailModel.fromJson(data);
      } else {
        throw AppException(message: data['message'] ?? 'Failed to load item');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      print('DEBUG ITEM DETAIL -> exception: $e');
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<void> deleteItem(int itemId) async {
    try {
      final headers = await getAuthHeaders(ref);
      final url = Uri.parse("${ApiUrls.itemsUrl}/$itemId");

      final response = await http.delete(url, headers: headers);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final data = jsonDecode(response.body);
        throw AppException(message: data['message'] ?? 'Failed to delete item');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<List<ItemListItemModel>> getItems({
    int? categoryId,
    String? search,
  }) async {
    try {
      final headers = await getAuthHeaders(ref);

      final queryParams = <String, String>{"sort": "expiry_asc"};
      if (categoryId != null) queryParams["category"] = categoryId.toString();
      if (search != null && search.isNotEmpty) queryParams["search"] = search;

      final url = Uri.parse(
        ApiUrls.itemsUrl,
      ).replace(queryParameters: queryParams);
      print('DEBUG GET ITEMS -> url: $url');

      final response = await http.get(url, headers: headers);
      final data = jsonDecode(response.body);
      print('DEBUG GET ITEMS -> statusCode: ${response.statusCode}');
      print('DEBUG GET ITEMS -> body: ${response.body}');

      if (response.statusCode == 200) {
        return (data as List)
            .map((json) => ItemListItemModel.fromJson(json))
            .toList();
      } else {
        throw AppException(message: data['message'] ?? 'Failed to load items');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<void> updateItem(int itemId, AddItemRequestModel request) async {
    try {
      final headers = await getAuthHeaders(ref);
      final url = Uri.parse("${ApiUrls.itemsUrl}/$itemId");

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw AppException(message: data['message'] ?? 'Failed to update item');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }
}
