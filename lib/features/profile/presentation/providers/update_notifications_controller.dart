import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_providers.dart';

class UpdateNotificationsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateNotifications(bool enabled) async {
    state = const AsyncValue.loading();
    final usecase = ref.read(updateNotificationsUsecaseProvider);
    state = await AsyncValue.guard(() => usecase(enabled));
  }
}

final updateNotificationsControllerProvider =
    AsyncNotifierProvider<UpdateNotificationsController, void>(
  UpdateNotificationsController.new,
);