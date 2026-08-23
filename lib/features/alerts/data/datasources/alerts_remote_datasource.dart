import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/core/constants/api_urls.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/core/network/api_headers.dart';
import '../models/alert_model.dart';

class AlertsRemoteDatasource {
  final Ref ref;
  AlertsRemoteDatasource(this.ref);

  Future<List<AlertModel>> getAlerts() async {
    try {
      final headers = await getAuthHeaders(ref);
      final response = await http.get(Uri.parse(ApiUrls.alertsUrl), headers: headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (data as List).map((json) => AlertModel.fromJson(json)).toList();
      } else {
        throw AppException(message: data['message'] ?? 'Failed to load alerts');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }
}