class ProfileModel {
  final String name;
  final String email;
  final String memberSince;
  final int totalItems;
  final int reminderDaysBefore;
  final bool notificationsEnabled;

  ProfileModel({
    required this.name,
    required this.email,
    required this.memberSince,
    required this.totalItems,
    required this.reminderDaysBefore,
    required this.notificationsEnabled,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      memberSince: json['member_since'],
      totalItems: json['total_items'],
      reminderDaysBefore: json['reminder_days_before'],
      notificationsEnabled: json['notifications_enabled'] == true || json['notifications_enabled'] == 1,
    );
  }
}