import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/register_response_model.dart';
import 'auth_providers.dart';

class RegisterController extends AsyncNotifier<RegisterResponseModel?> {
  @override
  FutureOr<RegisterResponseModel?> build() {
    // Initial state — kuch register nahi hua abhi
    return null;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncValue.loading();

    final requestPayload = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    print('🟢 [RegisterScreen] ➜ Register request payload: $requestPayload');

    final usecase = ref.read(registerUsecaseProvider);

    state = await AsyncValue.guard(() {
      return usecase(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    });

    state.when(
      data: (response) {
        print('✅ [RegisterScreen] ← Register response: $response');
      },
      error: (err, stack) {
        print('❌ [RegisterScreen] ← Register error: $err');
      },
      loading: () {},
    );
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, RegisterResponseModel?>(
      RegisterController.new,
    );
