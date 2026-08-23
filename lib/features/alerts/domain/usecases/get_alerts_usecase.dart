import '../../data/models/alert_model.dart';
import '../repositories/alerts_repository.dart';

class GetAlertsUsecase {
  final AlertsRepository repository;
  GetAlertsUsecase(this.repository);

  Future<List<AlertModel>> call() {
    return repository.getAlerts();
  }
}