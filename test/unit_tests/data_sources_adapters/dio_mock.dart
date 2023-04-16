import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import '../domain/data_sources/fakes/fake_data.dart';

class MockDio extends Mock implements Dio {
  final _interceptors = Interceptors();
  @override
  Interceptors get interceptors => _interceptors;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    super.noSuchMethod(
      Invocation.method(
        #get,
        [path],
        {
          #queryParameters: queryParameters,
          #options: options,
          #cancelToken: cancelToken,
          #onReceiveProgress: onReceiveProgress
        },
      ),
    );
    return Response(
      data: (fakePokemonJson as dynamic),
      requestOptions: RequestOptions(path: path),
    );
  }
}
