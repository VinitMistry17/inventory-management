import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/storage/provider/storage_providers.dart';
import 'package:inventory_management/features/auth/data/models/login_response_model.dart';
import 'package:inventory_management/features/auth/presentation/providers/auth_providers.dart';

class LoginController extends AsyncNotifier<LoginResponseModel?> {
  @override
  FutureOr<LoginResponseModel?> build() {
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    state = AsyncValue.loading();

    final usecase = ref.read(loginUsecaseProvider);

    state = await AsyncValue.guard(() {
      return usecase(email: email, password: password);
    });

    //save token
    if(state.hasValue && state.value != null){
      final token = state.value!.token;
      ref.read(tokenStorageProvider).saveToken(token);
    }
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, LoginResponseModel?>(
      LoginController.new,
    );
