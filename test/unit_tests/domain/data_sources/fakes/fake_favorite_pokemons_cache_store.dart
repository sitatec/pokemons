import 'package:flutter/cupertino.dart';
import 'package:podedex/domain/data_sources/favorite_pokemons_cache_store.dart';

class FakeFavoritePokemonsCacheStore extends ChangeNotifier
    implements FavoritePokemonsCacheStore {
  bool _isFavorite = true;

  bool get isFavorite => _isFavorite;

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  Exception? exception;

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
  Future<void> addPokemonToFavorites(int pokemonId) async {
    if (exception != null) {
      throw exception!;
    }
    isFavorite = true;
  }

  @override
  Future<int> get favoritePokemonsCount async => 55;

  @override
  Future<void> removePokemonFromFavorites(int pokemonId) async {
    if (exception != null) {
      throw exception!;
    }
    isFavorite = false;
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Future<bool> isFavoritePokemon(int pokemonId) async {
    return isFavorite;
  }
}
