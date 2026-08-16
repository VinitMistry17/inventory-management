import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category_model.dart';
import 'items_providers.dart';

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final usecase = ref.watch(getCategoriesUsecaseProvider);
  return usecase();
});