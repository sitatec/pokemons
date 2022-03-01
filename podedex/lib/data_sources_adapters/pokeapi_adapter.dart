import '../domain/data_sources/http_client.dart';
import '../domain/data_sources/pokemons_remote_data_source.dart';

import '../domain/data_sources/constant.dart';
import '../domain/data_sources/utils/data_converters.dart';
import '../domain/entities/pokemon.dart';

class PokeapiAdapter implements PokemonsRemoteDataSource {
  final HttpClient _httpClient;

  PokeapiAdapter(this._httpClient);

  @override
  Future<int> get allPokemonsCount async {
    const url = "$pokemonEndpoint?limit=1";
    final httpResponseData = await _httpClient.get(url, retryCount: 2);
    return httpResponseData["count"];
  }

  @override
  Future<List<Pokemon>> getPokemons({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    final url = _buildPokemonsRequestUrl(pageNumber, pageLength);
    final httpResponseData = await _httpClient.get(url, retryCount: 2);
    final pokemonsPartialData = httpResponseData["results"];
    final pokemonsUrls =
        pokemonsPartialData.map<String>((currentPockemonPartialData) {
      return currentPockemonPartialData["url"] as String;
    });
    return fetchPokemonsUrls(pokemonsUrls.toList(growable: false));
  }

  String _buildPokemonsRequestUrl(int pageNumber, int pageLength) =>
      "$pokemonEndpoint?limit=$pageLength&offset=${pageLength * pageNumber}";

  @override
  Future<List<Pokemon>> fetchPokemonsUrls(List<String> pokemonsUrls) async {
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
      }
      // Some request in the batch failed. Report (e.g: Crashlytics).
      // TODO check on the ui side that the returned list length matches the
      // pageLength otherwise notify the user that some items failed to load.
    }
    return fetchedPokemons.map(pokemonfromJson).toList(growable: false);
  }
}
