import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:podedex/domain/data_sources/http_client.dart';

class DioAdapter implements HttpClient {
  final Dio _dio;
  late var _currentInterseptor = RetryInterceptor(dio: _dio);
  DioAdapter([Dio? dio]) : _dio = dio ?? Dio() {
    _dio.interceptors.add(_currentInterseptor);
  }

  @override
  Future<JsonObject> get(String url, {int retryCount = 0}) async {
    try {
      updateInterseptor(retryCount);
      final httpResponse = await _dio.get(url);
      return httpResponse.data;
    } on DioError catch (error) {
      throw HttpException(
        statusCode: error.response!.statusCode ?? -1,
        message: error.message,
      );
    }
  }

  void updateInterseptor(int retryCount) {
    if (_currentInterseptor.retries != retryCount) {
      _dio.interceptors.remove(_currentInterseptor);
      _currentInterseptor = RetryInterceptor(dio: _dio, retries: retryCount);
      _dio.interceptors.add(_currentInterseptor);
    }
  }
}
