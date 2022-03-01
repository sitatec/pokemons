import 'package:flutter/cupertino.dart';

import '../../data_sources_adapters/sqflite_adapter.dart';

/// The class that manages the favorite pokemons
abstract class FavoritePokemonsCacheStore extends ChangeNotifier {
  /// The number of favorite pokemons currently in cache.
  Future<int> get favoritePokemonsCount;

  /// Instantiate a new [FavoritePokemonsCacheStore];
  factory FavoritePokemonsCacheStore() => SqfliteAdapter();

  /// Return the [FavoritePokemonsCacheStore]'s `Singleton`.
  static final instance = SqfliteAdapter();

  /// Returns the favorite pokemons page by page.
  ///
  /// [pageNumber] represents the number of the page to return and [pageLength]
  /// represents the pokemons count to return. [pageNumber] start at 0.
  ///
  /// E.g: pageNumber = 0, pageLength = 30 will return the first page with
  /// a limit of 30 pokemons per page.
  Future<List<int>> getFavoritePokemonIds({
    int pageNumber = 0,
    int pageLength = 30,
  });

  /// Add the pokemon identified by [pokemonId] to the favorites.
  ///
  /// If the [pokemonId] already exist in the favorites, the existing value
  /// will be overridden, which won't chagne anything.
  Future<void> addPokemonToFavorites(int pokemonId);

  /// Remove the pokemon identified by [pokemonId] from the favorites.
  Future<void> removePokemonFromFavorites(int pokemonId);

  Future<bool> isFavoritePokemon(int pokemonId);

  /// Free all the ressouces used by this instance.
  @override
  Future<void> dispose();
}

/// Thrown when an error happens while interacting with the Cache Store.
class FavoritePokemonsCacheException implements Exception {
  /// The error message.
  final String message;

  /// Instantiate a [FavoritePokemonsCacheException].
  FavoritePokemonsCacheException(this.message);
}
