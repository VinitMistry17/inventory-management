import 'package:inventory_management/features/auth/data/models/login_response_model.dart';
import 'package:inventory_management/features/auth/data/models/register_response_model.dart';

abstract class AuthRepository {

  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
  
}