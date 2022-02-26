import 'package:dio/dio.dart';
import 'package:dio_retry_fixed/dio_retry_fixed.dart';
import 'package:podedex/domain/data_sources/http_client.dart';

class DioAdapter implements HttpClient {
  final Dio _dio;

  DioAdapter([Dio? dio]) : _dio = dio ?? Dio() {
    _dio.interceptors.add(RetryInterceptor(dio: _dio));
  }

  @override
  Future<JsonObject> get(String url, {int retryCount = 0}) async {
    try {
      final httpResponse = await _dio.get(
        url,
        options: Options(extra: _getRetryExtra(retryCount)),
      );
      return httpResponse.data;
    } on DioError catch (error) {
      throw HttpException(
        statusCode: error.response!.statusCode ?? -1,
        message: error.message,
      );
    }
  }

  Map<String, dynamic> _getRetryExtra(int retryCount) {
    return RetryOptions(retries: retryCount, retryInterval: Duration.zero)
        .toExtra();
  }
}
