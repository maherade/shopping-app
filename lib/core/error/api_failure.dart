class ApiFailure implements Exception {
  const ApiFailure(
    this.message, {
    this.network = false,
    this.unauthorized = false,
  });
  final String message;
  final bool network, unauthorized;

  @override
  String toString() => message;
}

class UnexpectedFailure extends ApiFailure {
  const UnexpectedFailure(super.message);
}
