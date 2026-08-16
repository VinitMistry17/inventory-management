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

      print('DEBUG CATEGORY FETCH -> statusCode: ${response.statusCode}');
      print('DEBUG CATEGORY FETCH -> body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final categories = (data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        print('DEBUG CATEGORY FETCH -> parsed count: ${categories.length}');
        return categories;
      } else {
        print(
          'DEBUG CATEGORY FETCH -> error message: ${data['message'] ?? 'Failed to load categories'}',
        );
        throw AppException(
          message: data['message'] ?? 'Failed to load categories',
        );
      }
    } on AppException {
      print('DEBUG CATEGORY FETCH -> AppException: $this');
      rethrow;
    } catch (e) {
      print('DEBUG CATEGORY FETCH -> catch error: $e');
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
}
