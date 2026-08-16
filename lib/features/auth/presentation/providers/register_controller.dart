import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/storage/provider/storage_providers.dart';
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

    final usecase = ref.read(registerUsecaseProvider);

    state = await AsyncValue.guard(() {
      return usecase(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    });

    //save token
    if(state.hasValue && state.value != null){
      final token = state.value!.token;
      await ref.read(tokenStorageProvider).saveToken(token);
    }
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, RegisterResponseModel?>(
      RegisterController.new,
    );
