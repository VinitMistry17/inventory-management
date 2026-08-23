import '../repositories/profile_repository.dart';

class UpdateNotificationsUsecase {
  final ProfileRepository repository;
  UpdateNotificationsUsecase(this.repository);

  Future<void> call(bool enabled) => repository.updateNotifications(enabled);
}