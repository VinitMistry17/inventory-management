import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory_management/core/constants/api_urls.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/auth/data/models/login_request_model.dart';
import 'package:inventory_management/features/auth/data/models/login_response_model.dart';
import 'package:inventory_management/features/auth/data/models/register_request_model.dart';
import 'package:inventory_management/features/auth/data/models/register_response_model.dart';

class AuthRemoteDatasource {
  //register
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final payload = request.toJson();
      print('🟢 [Register API] ➜ POST ${ApiUrls.registerUrl}');
      print('   payload: $payload');

      final response = await http.post(
        Uri.parse(ApiUrls.registerUrl),
        body: payload,
      );

      final data = jsonDecode(response.body);
      print('⬅️ [Register API] status: ${response.statusCode}');
      print('   response body: $data');

      if (response.statusCode == 201) {
        return RegisterResponseModel.fromJson(data);
      } else if (response.statusCode == 422) {
        throw AppException(
          message: data['message'] ?? 'Validation failed',
          errors: data['errors'],
        );
      } else {
        throw AppException(message: data['message'] ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      print('⚠️ [Register API] exception: $e');
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  //login
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.loginUrl),
        body: request.toJson(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(data);
      } else if (response.statusCode == 422) {
        throw AppException(
          message: data['message'] ?? 'Validation failed',
          errors: data['errors'],
        );
      } else {
        throw AppException(message: data['message'] ?? 'Something went wrong');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }
}
