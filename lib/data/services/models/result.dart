class Result<T> {
  final int statusCode;
  final String message;
  final T? data;

  Result({
    required this.statusCode,
    required this.message,
    this.data,
  });
}