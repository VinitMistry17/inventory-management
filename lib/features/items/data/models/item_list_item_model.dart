class ItemListItemModel {
  final int id;
  final String name;
  final int categoryId;
  final String purchaseDate;
  final bool hasExpiry;
  final String? expiryDate;
  final String pricePaid;
  final String location;
  final String qrCode;

  ItemListItemModel({
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

  factory ItemListItemModel.fromJson(Map<String, dynamic> json) {
    return ItemListItemModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      purchaseDate: json['purchase_date'],
      hasExpiry: json['has_expiry'] == true || json['has_expiry'] == 1, // wahi int/bool fix
      expiryDate: json['expiry_date'],
      pricePaid: json['price_paid'].toString(),
      location: json['location'],
      qrCode: json['qr_code'],
    );
  }
}