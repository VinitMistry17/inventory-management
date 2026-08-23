import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<void> updateNotifications(bool enabled);
  Future<void> updateReminderTiming(int daysBefore);
  Future<void> logout();
}