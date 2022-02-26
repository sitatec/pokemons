import 'package:podedex/domain/data_sources/favorite_pokemons_cache_store.dart';

class FakeFavoritePokemonsCacheStore implements FavoritePokemonsCacheStore {
  @override
  Future<List<int>> getFavoritePokemonIds({
    int pageNumber = 0,
    int pageLength = 30,
  }) {
    final pokemonIds = <int>[];

    for (int i = pageNumber + 1; i <= pageLength; i++) {
      pokemonIds.add((pageNumber * pageLength) + 1);
    }

    return Future.value(pokemonIds);
  }

  @override
  Future<void> addPokemonToFavorites(int pokemonId) {
    throw UnimplementedError();
  }

  @override
  Future<int> get favoritePokemonsCount => throw UnimplementedError();

  @override
  Future<void> removePokemonFromFavorites(int pokemonId) {
    throw UnimplementedError();
  }
}