class DocumentUploadResponseModel {
  final String documentUrl;

  DocumentUploadResponseModel({required this.documentUrl});

  factory DocumentUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponseModel(
      documentUrl: json['document_url'],
    );
  }
}