class ItemResponseModel {
  final int id;
  final String name;
  final int categoryId;
  final String purchaseDate;
  final bool hasExpiry;
  final String? expiryDate;
  final String pricePaid; // API string bhejta hai ("52000.00")
  final String location;
  final String qrCode;

  ItemResponseModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.purchaseDate,
    required this.hasExpiry,
    this.expiryDate,
    required this.pricePaid,
    required this.location,
    required this.qrCode,
  });

  factory ItemResponseModel.fromJson(Map<String, dynamic> json) {
    return ItemResponseModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      purchaseDate: json['purchase_date'],
      hasExpiry: json['has_expiry'],
      expiryDate: json['expiry_date'],
      pricePaid: json['price_paid'].toString(),
      location: json['location'],
      qrCode: json['qr_code'],
    );
  }
}