import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<ProfileModel> getProfile() => remoteDatasource.getProfile();

  @override
  Future<void> updateNotifications(bool enabled) => remoteDatasource.updateNotifications(enabled);

  @override
  Future<void> updateReminderTiming(int daysBefore) => remoteDatasource.updateReminderTiming(daysBefore);

  @override
  Future<void> logout() => remoteDatasource.logout();
}