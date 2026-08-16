import 'package:inventory_management/core/storage/provider/storage_providers.dart';
import 'package:riverpod/riverpod.dart';

Future<Map<String, String>> getAuthHeaders(Ref ref) async {
  final token = await ref.read(tokenStorageProvider).getToken();

  return {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  };
}

Future<Map<String, String>> getAuthHeadersMultipart(Ref ref) async {
  final token = await ref.read(tokenStorageProvider).getToken();
  return {
    "Authorization": "Bearer $token",
    "Accept": "application/json",
  };
}