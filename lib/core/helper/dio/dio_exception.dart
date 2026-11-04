import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:dio/dio.dart';

export 'package:shopping_app_task/core/error/api_failure.dart';

abstract final class DioExceptions {
  static ApiFailure fromDioError(DioException error) {
    final network = switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => true,
      _ => false,
    };
    return network
        ? const ApiFailure(
            'Cannot reach the service. Check your connection and retry.',
            network: true,
          )
        : fromStatusCode(error.response?.statusCode);
  }

  static ApiFailure fromStatusCode(int? code) => ApiFailure(
    code == 400 || code == 401 || code == 403
        ? 'Session expired or credentials rejected. Please sign in again.'
        : code == 429
        ? 'Too many requests. Please try again shortly.'
        : 'The service could not complete the request. Please retry.',
    unauthorized: code == 401 || code == 403,
  );
}
