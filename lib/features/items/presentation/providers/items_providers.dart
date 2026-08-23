import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/features/items/domain/usecases/create_category_usecase.dart';
import 'package:inventory_management/features/items/domain/usecases/delete_item_usecase.dart';
import 'package:inventory_management/features/items/domain/usecases/get_item_detail_usecase.dart';
import 'package:inventory_management/features/items/domain/usecases/get_items_usecase.dart';
import 'package:inventory_management/features/items/domain/usecases/update_item_usecase.dart';
import '../../data/datasources/items_remote_datasource.dart';
import '../../data/repositories/items_repository_impl.dart';
import '../../domain/repositories/items_repository.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/create_item_usecase.dart';
import '../../domain/usecases/upload_photos_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';

// Step 1: Datasource provider — is baar 'ref' pass karna hai (auth mein nahi karna pada tha)
final itemsRemoteDatasourceProvider = Provider<ItemsRemoteDatasource>((ref) {
  return ItemsRemoteDatasource(ref);
});

// Step 2: Repository provider
final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  final datasource = ref.watch(itemsRemoteDatasourceProvider);
  return ItemsRepositoryImpl(datasource);
});

// Step 3: Usecase providers — 4 alag, sab same repository use karte hain
final getCategoriesUsecaseProvider = Provider<GetCategoriesUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return GetCategoriesUsecase(repository);
});

final createItemUsecaseProvider = Provider<CreateItemUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return CreateItemUsecase(repository);
});

final uploadPhotosUsecaseProvider = Provider<UploadPhotosUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return UploadPhotosUsecase(repository);
});

final uploadDocumentUsecaseProvider = Provider<UploadDocumentUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return UploadDocumentUsecase(repository);
});

final createCategoryUsecaseProvider = Provider<CreateCategoryUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return CreateCategoryUsecase(repository);
});

final getItemDetailUsecaseProvider = Provider<GetItemDetailUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return GetItemDetailUsecase(repository);
});

final deleteItemUsecaseProvider = Provider<DeleteItemUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return DeleteItemUsecase(repository);
});

final getItemsUsecaseProvider = Provider<GetItemsUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return GetItemsUsecase(repository);
});

final updateItemUsecaseProvider = Provider<UpdateItemUsecase>((ref) {
  final repository = ref.watch(itemsRepositoryProvider);
  return UpdateItemUsecase(repository);
});