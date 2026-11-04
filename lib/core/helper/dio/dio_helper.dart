import 'package:dio/dio.dart';
import 'package:shopping_app_task/core/helper/dio/end_points.dart';

class DioHelper {
  DioHelper({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: EndPoints.baseUrl,
              connectTimeout: const Duration(seconds: 12),
              sendTimeout: const Duration(seconds: 12),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  final Dio dio;

  Future<Response<T>> request<T>({
    required String method,
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => dio.request<T>(
    url,
    queryParameters: query,
    data: data,
    cancelToken: cancelToken,
    options: (options ?? Options()).copyWith(
      method: method,
      contentType:
          options?.contentType ??
          (data is FormData
              ? Headers.multipartFormDataContentType
              : Headers.jsonContentType),
      responseType: options?.responseType ?? ResponseType.json,
      headers: {
        'Accept': 'application/json',
        ...?headers,
        ...?options?.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      validateStatus: (status) => true,
      followRedirects: false,
    ),
  );
}
