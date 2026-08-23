import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/core/constants/api_urls.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/core/network/api_headers.dart';
import '../models/dashboard_model.dart';

class HomeRemoteDatasource {
  final Ref ref;
  HomeRemoteDatasource(this.ref);

  Future<DashboardModel> getDashboard() async {
    try {
      final headers = await getAuthHeaders(ref);
      final response = await http.get(
        Uri.parse(ApiUrls.dashboardUrl),
        headers: headers,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DashboardModel.fromJson(data);
      } else {
        throw AppException(
          message: data['message'] ?? 'Failed to load dashboard',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }
}
