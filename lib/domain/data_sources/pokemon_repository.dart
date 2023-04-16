import 'dart:async';

import '../entities/pokemon.dart';
import 'constant.dart';
import 'favorite_pokemons_cache_store.dart';
import 'pokemons_remote_data_source.dart';

/// The pokemons data repository
///
/// This class is the only pokemon data source we should use in the whole app to
/// reduce parts of the app that may be affected by pokeapi's API changes.
class PokemonRepository {
  final PokemonsRemoteDataSource _pokemonsRemoteDataSource;
  final FavoritePokemonsCacheStore _favoritePokemonsStore;
  final String _pokemonEndpointBaseUrl;

  /// Construct a [PokemonRepository].
  PokemonRepository(
    this._pokemonsRemoteDataSource,
    this._favoritePokemonsStore, [
    String? pokemonEndpointBaseUrl,
  ]) : _pokemonEndpointBaseUrl = pokemonEndpointBaseUrl ?? pokemonEndpoint;

  /// Returns the total number of pokemons. If [favoritesOnly] is true only
  /// the favorite pokemons count will be returned.
  Future<int> getPokemonsCount({bool favoritesOnly = false}) {
    if (favoritesOnly) {
      return _favoritePokemonsStore.favoritePokemonsCount;
    } else {
      return _pokemonsRemoteDataSource.allPokemonsCount;
    }
  }

  /// Fetches [pageLength] pokemons from the API at the page [pageNumber].
  /// [pageNumber] start at 0.
  ///
  /// If [favoritesOnly] is `true`, only the favorite pokemons will be returned.
  ///
  /// E.g: pageNumber = 0, pageLength = 30 will return the first page with
  /// a limit of 30 pokemons per page.
  Future<List<Pokemon>> getPokemons({
    int pageNumber = 0,
    int pageLength = 30,
    bool favoritesOnly = false,
  }) async {
    _assertPositivePageArguments(pageNumber, pageLength);
    if (favoritesOnly) {
      final favoritePokemonsUrls = await _getFavoritePokemonsUrls(
        pageLength: pageLength,
        pageNumber: pageNumber,
      );
      return _pokemonsRemoteDataSource.fetchPokemonsUrls(favoritePokemonsUrls);
    } else {
      return _pokemonsRemoteDataSource.getPokemons(
        pageNumber: pageNumber,
        pageLength: pageLength,
      );
    }
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

  Future<List<String>> _getFavoritePokemonsUrls({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    final favoritePokemonIds = await _favoritePokemonsStore
        .getFavoritePokemonIds(pageNumber: pageNumber, pageLength: pageLength);
    return favoritePokemonIds.map(_pokemonIdToUrl).toList(growable: false);
  }

  String _pokemonIdToUrl(int pokemonId) =>
      "$_pokemonEndpointBaseUrl/$pokemonId";
}
