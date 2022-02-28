import 'package:podedex/domain/data_sources/http_client.dart';
import 'package:podedex/domain/data_sources/pokemons_remote_data_source.dart';
import 'package:podedex/domain/data_sources/utils/data_converters.dart';
import 'package:podedex/domain/entities/pokemon.dart';

import 'fake_data.dart';

class FakePokemonsRemoteDataSource implements PokemonsRemoteDataSource {
  @override
  Future<int> get allPokemonsCount async => 1126;

  Exception? exception;

  void _throwExceptionIfPresent() {
    if (exception != null) {
      throw exception!;
    }
  }

  @override
  Future<List<Pokemon>> fetchPokemonsUrls(List<String> pokemonsUrls) async {
    _throwExceptionIfPresent();
    final pokemons = <Pokemon>[];
    JsonObject currentPokemonJson;
    int currentPokemonId;
    for (String url in pokemonsUrls) {
      //https://pokeapi.co/api/v2/pokemon/{ID}
      currentPokemonId = int.parse(url.split("/").last);
      currentPokemonJson = newFakePokemonJson..["id"] = currentPokemonId;
      pokemons.add(pokemonfromJson(currentPokemonJson));
    }
    return pokemons;
  }

  @override
  Future<List<Pokemon>> getPokemons({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    _throwExceptionIfPresent();
    final pokemons = <Pokemon>[];
    final offset = pageNumber * pageLength;
    JsonObject currentPokemonJson;
    for (int i = 1; i <= pageLength; i++) {
      currentPokemonJson = newFakePokemonJson..["id"] = offset + i;
      pokemons.add(pokemonfromJson(currentPokemonJson));
    }
    return pokemons;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
