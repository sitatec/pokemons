import '../../data_sources_adapters/pokeapi_adapter.dart';
import 'http_client.dart';

import '../entities/pokemon.dart';

abstract class PokemonsRemoteDataSource {
  factory PokemonsRemoteDataSource() => PokeapiAdapter(HttpClient.instance);

  Future<int> get allPokemonsCount;

  /// Fetches [pageLength] pokemons from the API at the page [pageNumber].
  /// [pageNumber] start at 0.
  ///
  /// E.g: pageNumber = 0, pageLength = 30 will return the first page with
  /// a limit of 30 pokemons per page.
  ///
  /// **NOTE** The method may return a number of pokemons smaller than [pageLength] if
  ///  We are loading the last page and the number ofremaining pokemons is smaller than [pageLength].
  Future<List<Pokemon>> getPokemons({
    int pageNumber = 0,
    int pageLength = 30,
  });

  /// Fetches all the given [pokemonsUrls] and return all the results as a single
  /// list of [Pokemon]s.
  ///
  /// If some urls failed to load and some succeed the successfully loaded ones
  /// will be returned. If all failed an `Exception` will be thrown.
  Future<List<Pokemon>> fetchPokemonsUrls(List<String> pokemonsUrls);
}
