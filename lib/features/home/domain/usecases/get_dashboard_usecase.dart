import '../../data/models/dashboard_model.dart';
import '../repositories/home_repository.dart';

class GetDashboardUsecase {
  final HomeRepository repository;
  GetDashboardUsecase(this.repository);

  Future<DashboardModel> call() {
    return repository.getDashboard();
  }
}