class RecentItemModel {
  final int id;
  final String name;
  final int categoryId;
  final String? expiryDate;

  RecentItemModel({
    required this.id,
    required this.name,
    required this.categoryId,
    this.expiryDate,
  });

  factory RecentItemModel.fromJson(Map<String, dynamic> json) {
    return RecentItemModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      expiryDate: json['expiry_date'],
    );
  }
}

class TopAlertModel {
  final String name;
  final int daysLeft;

  TopAlertModel({required this.name, required this.daysLeft});

  factory TopAlertModel.fromJson(Map<String, dynamic> json) {
    return TopAlertModel(
      name: json['name'],
      daysLeft: json['days_left'],
    );
  }
}

class DashboardModel {
  final int totalItems;
  final int itemsNeedingAttention;
  final List<RecentItemModel> recentItems;
  final TopAlertModel? topAlert;

  DashboardModel({
    required this.totalItems,
    required this.itemsNeedingAttention,
    required this.recentItems,
    this.topAlert,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalItems: json['total_items'],
      itemsNeedingAttention: json['items_needing_attention'],
      recentItems: (json['recent_items'] as List)
          .map((item) => RecentItemModel.fromJson(item))
          .toList(),
      topAlert: json['top_alert'] != null ? TopAlertModel.fromJson(json['top_alert']) : null,
    );
  }
}