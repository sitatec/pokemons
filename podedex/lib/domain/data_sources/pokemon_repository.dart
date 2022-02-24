import 'constant.dart';
import 'favorite_pokemons_cache_store.dart';
import 'http_client.dart';
import '../entities/pokemon.dart';
import 'utils/data_converters.dart';

/// The pokemons data repository
///
/// This class is the only pokemon data source we should use in the whole app to
/// reduce parts of the app that may be affected by pokeapi's API changes.
class PokemonRepository {
  final HttpClient _httpClient;
  final FavoritePokemonsCacheStore _favoritePokemonsStore;
  final String _pokemonEndpointBaseUrl;

  /// Construct a [PokemonRepository].
  PokemonRepository(
    this._httpClient,
    this._favoritePokemonsStore, [
    String? pokemonEndpointBaseUrl,
  ]) : _pokemonEndpointBaseUrl = pokemonEndpointBaseUrl ?? pokemonEndpoint;

  /// Fetches [pageLength] pokemons from the API at the page [pageNumber].
  /// [pageNumber] start at 0.
  ///
  /// E.g: pageNumber = 0, pageLength = 30 will return the first page with
  /// a limit of 30 pokemons per page.
  Future<List<Pokemon>> getPokemons({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    _assertPositivePageArguments(pageNumber, pageLength);
    final url =
        "$_pokemonEndpointBaseUrl?limit=$pageLength&offset=${pageLength * pageNumber}";
    final httpResponseData = await _httpClient.get(url, retryCount: 2);
    final Iterable<JsonObject> pokemonsPartialData =
        httpResponseData["results"];
    final pokemonsUrls = pokemonsPartialData.map((currentPockemonPartialData) {
      return currentPockemonPartialData["url"] as String;
    });
    return _fetchAllPokemonsUrls(pokemonsUrls.toList(growable: false));
  }

  /// Fetches [pageLength] **favorites** pokemons at the page [pageNumber].
  /// [pageNumber] must be >= 0 and [pageLength] >= 1.
  ///
  /// E.g: pageNumber = 0, pageLength = 30 will return the first page with
  /// a limit of 30 pokemons per page.
  ///
  /// Throws an [InvalidArgumentException] if [pageNumber] is negative or if [pageLength] < 1.
  Future<List<Pokemon>> getFavoritePokemons({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    _assertPositivePageArguments(pageNumber, pageLength);
    final favoritePokemonIds = await _favoritePokemonsStore
        .getFavoritePokemonIds(pageNumber: pageNumber, pageLength: pageLength);
    final favoritePokemonUrls = favoritePokemonIds.map(_pokemonIdToUrl);
    return _fetchAllPokemonsUrls(favoritePokemonUrls.toList(growable: false));
  }

  void _assertPositivePageArguments(int pageNumber, int pageLength) {
    if (pageNumber < 0) {
      throw ArgumentError.value(
        pageNumber,
        "pageNumber",
        "The argument [pageNumber] must be greater or equal to 0.",
      );
    }
    if (pageLength < 1) {
      throw ArgumentError.value(
        pageLength,
        "pageLength",
        "The argument [pageLength] must be greater or equal to 1.",
      );
    }
  }

  String _pokemonIdToUrl(int pokemonId) =>
      "$_pokemonEndpointBaseUrl/$pokemonId";

  Future<List<Pokemon>> _fetchAllPokemonsUrls(
    List<String> pokemonsUrls,
  ) async {
    final pokemonReqeusts = <Future<JsonObject>>[];
    for (String pokemonUrl in pokemonsUrls) {
      // Create a batch of requests that will be executed parallelly instead of
      //`awaiting` them one by one, which would be slower.
      pokemonReqeusts.add(_httpClient.get(pokemonUrl, retryCount: 1));
    }
    var fetchedPokemons = <JsonObject>[];
    try {
      fetchedPokemons =
          await Future.wait(pokemonReqeusts, cleanUp: fetchedPokemons.add);
    } catch (e) {
      if (fetchedPokemons.isEmpty) {
        rethrow;
      } else {
        // Some request in the batch failed. Report (e.g: Crashlytics).
        // TODO check on the ui side that the returned list length matches the
        // pageLength otherwise notify the user that some items failed to load.
      }
    }
    return fetchedPokemons.map(pokemonfromJson).toList(growable: false);
  }
}
