import 'dart:io';
import '../../data/models/document_upload_response_model.dart';
import '../repositories/items_repository.dart';

class UploadDocumentUsecase {
  final ItemsRepository repository;
  UploadDocumentUsecase(this.repository);

  Future<DocumentUploadResponseModel> call(int itemId, File document) {
    return repository.uploadDocument(itemId, document);
  }
}