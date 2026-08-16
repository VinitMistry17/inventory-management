import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inventory_management/core/storage/token_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref){
  return const FlutterSecureStorage();
});

final tokenStorageProvider = Provider<TokenStorage>((ref){
  final secureStorage = ref.watch(secureStorageProvider);
  return TokenStorage(secureStorage);
});