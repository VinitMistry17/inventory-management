import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_remote_datasource.dart';
import '../models/alert_model.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsRemoteDatasource remoteDatasource;
  AlertsRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<AlertModel>> getAlerts() {
    return remoteDatasource.getAlerts();
  }
}