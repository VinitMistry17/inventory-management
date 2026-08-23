import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_notifications_usecase.dart';
import '../../domain/usecases/update_reminder_timing_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasource(ref);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final datasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(datasource);
});

final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  return GetProfileUsecase(ref.watch(profileRepositoryProvider));
});

final updateNotificationsUsecaseProvider = Provider<UpdateNotificationsUsecase>((ref) {
  return UpdateNotificationsUsecase(ref.watch(profileRepositoryProvider));
});

final updateReminderTimingUsecaseProvider = Provider<UpdateReminderTimingUsecase>((ref) {
  return UpdateReminderTimingUsecase(ref.watch(profileRepositoryProvider));
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(ref.watch(profileRepositoryProvider));
});

final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final usecase = ref.watch(getProfileUsecaseProvider);
  return usecase();
});