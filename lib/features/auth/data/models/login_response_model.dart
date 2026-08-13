import 'package:inventory_management/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final UserModel user;
  final String token;

  LoginResponseModel({
    required this.user,
    required this.token
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
    return LoginResponseModel(
      user: UserModel.fromJson(json["user"] as Map<String, dynamic>),
      token: json['token']
    );
  }
}