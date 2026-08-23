class ItemDetailModel {
  final int id;
  final String name;
  final int categoryId;
  final String categoryName;
  final String purchaseDate;
  final bool hasExpiry;
  final String? expiryDate;
  final String pricePaid;
  final String location;
  final List<String> photos;
  final String? documentUrl;
  final String qrCode;

  ItemDetailModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.purchaseDate,
    required this.hasExpiry,
    this.expiryDate,
    required this.pricePaid,
    required this.location,
    required this.photos,
    this.documentUrl,
    required this.qrCode,
  });

  factory ItemDetailModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      purchaseDate: json['purchase_date'],
      hasExpiry: json['has_expiry'] == true || json['has_expiry'] == 1,
      expiryDate: json['expiry_date'],
      pricePaid: json['price_paid'].toString(),
      location: json['location'],
      photos: List<String>.from(json['photos'] ?? []),
      documentUrl: json['document_url'],
      qrCode: json['qr_code'],
    );
  }
}