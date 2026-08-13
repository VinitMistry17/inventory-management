class AppException {
  final String message;
  final Map<String, dynamic>? errors;

  AppException({
    required this.message,
    this.errors
  });

  String toString() => message;
}