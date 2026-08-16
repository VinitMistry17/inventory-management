class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.isCustom,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final isCustomValue = json['is_custom'];

    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      isCustom: isCustomValue == true || isCustomValue == 1 || isCustomValue == '1',
    );
  }
}