import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/alerts_remote_datasource.dart';
import '../../data/repositories/alerts_repository_impl.dart';
import '../../data/models/alert_model.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../domain/usecases/get_alerts_usecase.dart';

final alertsRemoteDatasourceProvider = Provider<AlertsRemoteDatasource>((ref) {
  return AlertsRemoteDatasource(ref);
});

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final datasource = ref.watch(alertsRemoteDatasourceProvider);
  return AlertsRepositoryImpl(datasource);
});

final getAlertsUsecaseProvider = Provider<GetAlertsUsecase>((ref) {
  final repository = ref.watch(alertsRepositoryProvider);
  return GetAlertsUsecase(repository);
});

final alertsProvider = FutureProvider<List<AlertModel>>((ref) async {
  final usecase = ref.watch(getAlertsUsecaseProvider);
  return usecase();
});