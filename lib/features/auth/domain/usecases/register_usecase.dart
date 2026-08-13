import '../../data/models/register_response_model.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<RegisterResponseModel> call({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}