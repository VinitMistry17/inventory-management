import 'package:inventory_management/features/auth/data/models/login_response_model.dart';
import 'package:inventory_management/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  AuthRepository authRepository;

  LoginUsecase(this.authRepository);

  Future<LoginResponseModel> call({
    required String email,
    required String password
  }) async {
    return authRepository.login(email: email, password: password);
  }
}