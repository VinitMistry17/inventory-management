import 'package:flutter/material.dart';

IconData getCategoryIcon(String iconKey) {
  switch (iconKey) {
    case "electronics":
      return Icons.devices_other;
    case "insurance":
      return Icons.shield_outlined;
    case "documents":
      return Icons.description_outlined;
    case "furniture":
      return Icons.chair_outlined;
    case "books":
      return Icons.menu_book_outlined;
    case "shoes":
      return Icons.checkroom_outlined; // shoes ka koi exact Material icon nahi hai, closest fit
    default:
      return Icons.folder_outlined; // custom categories aur unknown icons ke liye fallback
  }
}