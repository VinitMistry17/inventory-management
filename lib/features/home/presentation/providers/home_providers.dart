import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/models/dashboard_model.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

final homeRemoteDatasourceProvider = Provider<HomeRemoteDatasource>((ref) {
  return HomeRemoteDatasource(ref);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final datasource = ref.watch(homeRemoteDatasourceProvider);
  return HomeRepositoryImpl(datasource);
});

final getDashboardUsecaseProvider = Provider<GetDashboardUsecase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetDashboardUsecase(repository);
});

final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  final usecase = ref.watch(getDashboardUsecaseProvider);
  return usecase();
});