import 'dart:io';
import '../../data/models/photo_upload_response_model.dart';
import '../repositories/items_repository.dart';

class UploadPhotosUsecase {
  final ItemsRepository repository;
  UploadPhotosUsecase(this.repository);

  Future<PhotoUploadResponseModel> call(int itemId, List<File> photos) {
    return repository.uploadPhotos(itemId, photos);
  }
}