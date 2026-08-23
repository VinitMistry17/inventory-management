import '../repositories/profile_repository.dart';

class LogoutUsecase {
  final ProfileRepository repository;
  LogoutUsecase(this.repository);

  Future<void> call() => repository.logout();
}