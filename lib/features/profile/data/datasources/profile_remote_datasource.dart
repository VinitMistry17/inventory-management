import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_management/core/constants/api_urls.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/core/network/api_headers.dart';
import '../models/profile_model.dart';

class ProfileRemoteDatasource {
  final Ref ref;
  ProfileRemoteDatasource(this.ref);

  Future<ProfileModel> getProfile() async {
    try {
      final headers = await getAuthHeaders(ref);
      final response = await http.get(Uri.parse(ApiUrls.profileUrl), headers: headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(data);
      } else {
        throw AppException(message: data['message'] ?? 'Failed to load profile');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<void> updateNotifications(bool enabled) async {
    try {
      final headers = await getAuthHeaders(ref);
      final response = await http.put(
        Uri.parse(ApiUrls.profileUrl),
        headers: headers,
        body: jsonEncode({"notifications_enabled": enabled}),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw AppException(message: data['message'] ?? 'Failed to update notifications');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<void> updateReminderTiming(int daysBefore) async {
    try {
      final headers = await getAuthHeaders(ref);
      final response = await http.put(
        Uri.parse(ApiUrls.reminderTimingUrl),
        headers: headers,
        body: jsonEncode({"reminder_days_before": daysBefore}),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw AppException(message: data['message'] ?? 'Failed to update reminder timing');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(message: 'Network error. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      final headers = await getAuthHeaders(ref);
      await http.post(Uri.parse(ApiUrls.logoutUrl), headers: headers);
      // Logout ke liye response fail bhi ho, hum local token toh clear kar hi denge (niche repository mein)
    } catch (e) {
      // Network fail ho toh bhi silently ignore - local logout hona hi chahiye
    }
  }
}