import '../../data_sources_adapters/dio_adapter.dart';

/// A HTTP client
///
/// We will depend only on this class (used here as an interface) to perform HTTP
/// requests in the business logic without directly depending on the API of an
/// external library. This way it doesn't matter if we change the http library
/// we are using or if the author of the library change its API, our business
/// loginc wont be affected since it depend on our own API.
///
/// In a production app, we would probabily make it more generic i.e: making it
/// possible to set base url and headers, add post, put, patch, delete...,
/// return a HTTP response object with more info about the response, and so on.
abstract class HttpClient {
  /// Instantiate a new [HttpClient]
  factory HttpClient() => DioAdapter();

  /// Return the [HttpClient]'s `Singleton`.
  static final instance = DioAdapter();

  /// Makes a http request to the given [url] using the [`GET` HTTP method](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET).
  /// If the request failed, it will automaticaly retry until the request succeed
  /// or it has retried [retryCount] times. By default it doesn't retry.
  ///
  /// Throws a [HttpException] on total failure (after retried [retryCount] times).
  Future<JsonObject> get(String url, {int retryCount = 0});

  /// Release all the ressources used by this client.
  ///
  /// After this mathod is called, this instance can't make requests anymore,
  /// you will need to instantiate a new one to perform new requests.
  void dispose();
}

/// An Exception thrown when an HTTP request fail.
class HttpException implements Exception {
  /// The HTTP response status code of the failed request.
  final int statusCode;

  /// A Human readable message describing the reason why the exception is thrown.
  final String message;

  /// Constructs a [HttpException]
  HttpException({required this.statusCode, required this.message});
}

/// A `Map<String, dynamic>` type alias that represent a JSON object (to improve readability).
typedef JsonObject = Map<String, dynamic>;
