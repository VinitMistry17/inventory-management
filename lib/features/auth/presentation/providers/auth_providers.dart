
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/features/auth/domain/usecases/login_usecase.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/register_usecase.dart';

// Step 1: Datasource provider
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource();
});

// Step 2: Repository provider — datasource ko andar use karta hai
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// Step 3: Usecase providers
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(repository);
});

final loginUsecaseProvider = Provider<LoginUsecase>((ref){
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
});
