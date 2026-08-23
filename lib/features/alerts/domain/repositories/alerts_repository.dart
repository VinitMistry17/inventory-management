import '../../data/models/alert_model.dart';

abstract class AlertsRepository {
  Future<List<AlertModel>> getAlerts();
}