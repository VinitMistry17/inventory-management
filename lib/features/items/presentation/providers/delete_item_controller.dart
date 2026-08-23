import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/features/alerts/presentation/providers/alerts_providers.dart';
import 'package:inventory_management/features/home/presentation/providers/home_providers.dart';
import 'items_provider.dart';
import 'items_providers.dart';

class DeleteItemController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> delete(int itemId) async {
    state = const AsyncValue.loading();
    final usecase = ref.read(deleteItemUsecaseProvider);
    state = await AsyncValue.guard(() => usecase(itemId));
    if (!state.hasError) {
      ref.invalidate(dashboardProvider);
      ref.invalidate(itemsProvider);
      ref.invalidate(alertsProvider);
    }
  }
}

final deleteItemControllerProvider =
    AsyncNotifierProvider<DeleteItemController, void>(DeleteItemController.new);
