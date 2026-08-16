class PhotoUploadResponseModel {
  final List<String> photos;

  PhotoUploadResponseModel({required this.photos});

  factory PhotoUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponseModel(
      photos: List<String>.from(json['photos']),
    );
  }
}