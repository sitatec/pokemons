import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podedex/domain/data_sources/constant.dart';
import 'package:podedex/domain/data_sources/http_client.dart';

import 'fake_data.dart';

// TODO comment

class FakeHttpClient extends Mock implements HttpClient {
  /// This array contains integer that indicate when to throw a HttpException
  ///
  /// E.g: for [2, 4, 7], an exception will be thrown the second, the fouth and
  /// seventh time the [get] function is invoked.
  final throwException = <int>[];

  /// Indicate how many time the [get] method have been called since the last
  /// reset.
  int _getCallsCount = 0;

  void resetGetCallsCount() => _getCallsCount = 0;

  @override
  Future<JsonObject> get(String url, {int retryCount = 0}) async {
    super.noSuchMethod(
      Invocation.method(#get, [url], {#retryCount: retryCount}),
    );
    _throwExceptionIfNeeded();
    final uri = Uri.parse(url);
    if (uri.hasQuery) {
      int offset = int.parse(uri.queryParameters["offset"]!);
      int limit = int.parse(uri.queryParameters["limit"]!);
      final results = <JsonObject>[];
      for (var i = 1; i <= limit; i++) {
        results.add({"url": "$pokemonEndpoint/${offset + i}"});
      }
      return {"results": results};
    }
    final requestedPokemonId = uri.pathSegments.last;
    return newFakePokemonJson..["id"] = int.parse(requestedPokemonId);
  }

  void _throwExceptionIfNeeded() {
    _getCallsCount++;
    if (throwException.isNotEmpty) {
      if (_getCallsCount == throwException.first) {
        throwException.removeAt(0);
        throw HttpException(statusCode: 404, message: "message");
      }
    }
  }
}
