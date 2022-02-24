import 'constant.dart';
import 'http_client.dart';
import '../entities/pokemon.dart';
import 'utils/data_converters.dart';

/// The pokemons data repository
///
/// This class is the only pokemon data source we should use in the whole app to
/// reduce parts of the app that may be affected by pokeapi's API changes.
class PokemonRepository {
  final HttpClient _httpClient;
  final String _pokemonEndpointBaseUrl;

  /// Construct a [PokemonRepository].
  PokemonRepository(this._httpClient, String? pokemonEndpointBaseUrl)
      : _pokemonEndpointBaseUrl = pokemonEndpointBaseUrl ?? pokemonEndpoint;

  /// Fetches [pageLength] of pokemons from the API at the page [pageNumber].
  /// [pageLength] start at 0.
  /// E.g: pageNumber = 0, pageLength = 30 will return the first page with
  /// a limit of 30 pokemons per page.
  Future<List<Pokemon>> getPokemons({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    final url =
        "$_pokemonEndpointBaseUrl?limit=$pageLength?offset=${pageLength * pageNumber}";
    final httpResponseData = await _httpClient.get(url);
    final Iterable<JsonObject> pokemonsPartialData =
        httpResponseData["results"];
    final pokemonsUrls = pokemonsPartialData.map(
      (currentPockemonPartialData) =>
          currentPockemonPartialData["url"] as String,
    );
    return _fetchAllPokemonsUrls(pokemonsUrls.toList(growable: false));
  }

  Future<List<Pokemon>> _fetchAllPokemonsUrls(
    List<String> pokemonsUrls,
  ) async {
    final pokemonReqeusts = <Future<JsonObject>>[];
    for (String pokemonUrl in pokemonsUrls) {
      pokemonReqeusts.add(_httpClient.get(pokemonUrl));
    }
    final pokemonRequestsAsSingleFuture = await Future.wait(pokemonReqeusts);
    return pokemonRequestsAsSingleFuture
        .map(pokemonfromJson)
        .toList(growable: false);
  }

  // Future<Pokemon> getPokemonById(String pokemonId) async {}
}
