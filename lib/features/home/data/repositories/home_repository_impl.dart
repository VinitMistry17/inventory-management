import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/dashboard_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;
  HomeRepositoryImpl(this.remoteDatasource);

  @override
  Future<DashboardModel> getDashboard() {
    return remoteDatasource.getDashboard();
  }
}