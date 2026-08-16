import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category_model.dart';
import 'items_providers.dart';

class CreateCategoryController extends AsyncNotifier<CategoryModel?> {
  @override
  FutureOr<CategoryModel?> build() {
    return null;
  }

  Future<void> create(String name) async {
    state = const AsyncValue.loading();

    final usecase = ref.read(createCategoryUsecaseProvider);

    state = await AsyncValue.guard(() => usecase(name));
  }

  // dialog band hote waqt state reset karne ke liye (taaki agli baar dialog khule toh purana result na dikhe)
  void reset() {
    state = const AsyncValue.data(null);
  }
}

final createCategoryControllerProvider =
    AsyncNotifierProvider<CreateCategoryController, CategoryModel?>(
  CreateCategoryController.new,
);