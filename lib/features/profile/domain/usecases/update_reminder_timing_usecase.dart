import '../repositories/profile_repository.dart';

class UpdateReminderTimingUsecase {
  final ProfileRepository repository;
  UpdateReminderTimingUsecase(this.repository);

  Future<void> call(int daysBefore) => repository.updateReminderTiming(daysBefore);
}