import 'package:inventory_management/features/auth/data/models/login_request_model.dart';
import 'package:inventory_management/features/auth/data/models/login_response_model.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  //register
  @override
  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    return remoteDatasource.register(request);
  }

  //login
  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(
      email: email,
      password: password
    );

    return remoteDatasource.login(request);
  }
}