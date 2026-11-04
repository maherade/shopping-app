import 'package:dio/dio.dart';
import 'package:shopping_app_task/core/helper/dio/dio_helper.dart';
import 'package:shopping_app_task/core/helper/dio/dio_exception.dart';

class ApiHelper {
  ApiHelper({required this.dioHelper});
  final DioHelper dioHelper;

  Future<T> parse<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw DioExceptions.fromDioError(error);
    } on FormatException {
      throw const ApiFailure(
        'The service returned invalid data. Please retry.',
      );
    } on TypeError {
      throw const ApiFailure(
        'The service returned unexpected data. Please retry.',
      );
    }
  }

  Future<Response<T>> request<T>({
    required String method,
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => parse(() async {
    final response = await dioHelper.request<dynamic>(
      method: method,
      url: url,
      query: query,
      headers: headers,
      data: data,
      token: token,
      options: options,
      cancelToken: cancelToken,
    );
    final status = response.statusCode;
    if (status == null || status < 200 || status >= 300) {
      throw DioExceptions.fromStatusCode(status);
    }
    return Response<T>(
      data: response.data as T?,
      requestOptions: response.requestOptions,
      headers: response.headers,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      extra: response.extra,
    );
  });

  Future<Response<T>> getData<T>({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    method: 'GET',
    url: url,
    query: query,
    headers: headers,
    data: data,
    token: token,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> postData<T>({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    method: 'POST',
    url: url,
    query: query,
    headers: headers,
    data: data,
    token: token,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> putData<T>({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    method: 'PUT',
    url: url,
    query: query,
    headers: headers,
    data: data,
    token: token,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> patchData<T>({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    method: 'PATCH',
    url: url,
    query: query,
    headers: headers,
    data: data,
    token: token,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> deleteData<T>({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Object? data,
    String? token,
    Options? options,
    CancelToken? cancelToken,
  }) => request<T>(
    method: 'DELETE',
    url: url,
    query: query,
    headers: headers,
    data: data,
    token: token,
    options: options,
    cancelToken: cancelToken,
  );
}
