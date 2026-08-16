class AddItemRequestModel {
  final String name;
  final int categoryId;
  final String purchaseDate; // "YYYY-MM-DD" format string
  final bool hasExpiry;
  final String? expiryDate; // null if hasExpiry false
  final double pricePaid;
  final String location;

  AddItemRequestModel({
    required this.name,
    required this.categoryId,
    required this.purchaseDate,
    required this.hasExpiry,
    this.expiryDate,
    required this.pricePaid,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "name": name,
      "category_id": categoryId,
      "purchase_date": purchaseDate,
      "has_expiry": hasExpiry,
      "price_paid": pricePaid,
      "location": location,
    };

    // has_expiry false hai toh expiry_date bhejna hi nahi (API ki requirement)
    if (hasExpiry && expiryDate != null) {
      map["expiry_date"] = expiryDate as Object;
    }

    return map;
  }
}