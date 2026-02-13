class NetworkResponse {
  final int? statusCode;
  final dynamic bodyData;
  final String message;

  const NetworkResponse({
    required this.message,
    this.statusCode,
    this.bodyData,
  });
}
