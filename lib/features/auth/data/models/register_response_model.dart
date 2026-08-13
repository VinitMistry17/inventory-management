import 'package:inventory_management/features/auth/data/models/user_model.dart';

class RegisterResponseModel {
  final UserModel user;
  final String token;

  RegisterResponseModel({required this.user, required this.token});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'],
    );
  }
}
