import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_providers.dart';

class UpdateReminderTimingController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateReminderTiming(int daysBefore) async {
    state = const AsyncValue.loading();
    final usecase = ref.read(updateReminderTimingUsecaseProvider);
    state = await AsyncValue.guard(() => usecase(daysBefore));
  }
}

final updateReminderTimingControllerProvider =
    AsyncNotifierProvider<UpdateReminderTimingController, void>(
  UpdateReminderTimingController.new,
);