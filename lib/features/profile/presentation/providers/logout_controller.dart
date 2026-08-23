import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/storage/provider/storage_providers.dart';
import 'profile_providers.dart';

class LogoutController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final usecase = ref.read(logoutUsecaseProvider);
      await usecase(); // best-effort backend call

      await ref.read(tokenStorageProvider).deleteToken(); // local cleanup - hamesha hona chahiye
    });
  }
}

final logoutControllerProvider = AsyncNotifierProvider<LogoutController, void>(
  LogoutController.new,
);