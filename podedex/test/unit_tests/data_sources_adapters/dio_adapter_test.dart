import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podedex/data_sources_adapters/dio_adapter.dart';
import 'package:podedex/domain/data_sources/http_client.dart';

import 'dio_mock.dart';

void main() {
  const fakeUrl = "url";

  final mockDio = MockDio();
  final dioAdapter = DioAdapter(mockDio);

  test("It should make GET request", () async {
    await dioAdapter.get(fakeUrl);
    verify(mockDio.get(fakeUrl));
  });

  test("DioAdapter should set an retry interceptor when instantiated", () {
    final _mockDio = MockDio();
    DioAdapter(_mockDio);
    expect(_mockDio.interceptors, isNotEmpty);
  });

  test("It should make GET request with retry", () async {
    const retryCount = 2;
    const retryCount1 = 5;
    await dioAdapter.get(fakeUrl, retryCount: retryCount);
    expect(
      (mockDio.interceptors.first as RetryInterceptor).retries,
      equals(retryCount),
    );

    await dioAdapter.get(fakeUrl, retryCount: retryCount1);
    expect(
      (mockDio.interceptors.first as RetryInterceptor).retries,
      equals(retryCount1),
    );
  });

  test("It should an Convert the DioError to HttpException", () {
    final requestOptions = RequestOptions(path: fakeUrl);
    const statusCode = 500;
    const erroMessage = "ErrorMessage";

    when(mockDio.get(fakeUrl)).thenThrow(
      DioError(
        requestOptions: requestOptions,
        response:
            Response(statusCode: statusCode, requestOptions: requestOptions),
        error: erroMessage,
      ),
    );

    expect(
      () async => await dioAdapter.get(fakeUrl),
      throwsA(
        isA<HttpException>()
            .having(
                (error) => error.statusCode, "statusCode", equals(statusCode))
            .having((error) => error.message, "message", equals(erroMessage)),
      ),
    );
  });

  test("It should release ressources", () {
    dioAdapter.dispose();
    verify(mockDio.close());
  });
}
