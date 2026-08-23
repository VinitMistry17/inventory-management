class AlertModel {
  final int itemId;
  final String name;
  final int categoryId;
  final String expiryDate;
  final int daysLeft;
  final String status; // "expired" | "warning" | "ok"

  AlertModel({
    required this.itemId,
    required this.name,
    required this.categoryId,
    required this.expiryDate,
    required this.daysLeft,
    required this.status,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      itemId: json['item_id'],
      name: json['name'],
      categoryId: json['category_id'],
      expiryDate: json['expiry_date'],
      daysLeft: json['days_left'],
      status: json['status'],
    );
  }
}