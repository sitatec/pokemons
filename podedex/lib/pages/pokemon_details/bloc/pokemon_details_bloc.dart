import 'dart:async';

import '../../../domain/data_sources/favorite_pokemons_cache_store.dart';
import 'pokemon_details_sate.dart';

class PokemonDetailsBloc {
  final FavoritePokemonsCacheStore _favoritePokemonsCacheStore;
  final int pokemonId;
  late final StreamController<PokemonDetailsState> _stateStreamController;
  PokemonDetailsState _currentState = PokemonDetailsState.initial();

  PokemonDetailsBloc(this._favoritePokemonsCacheStore, this.pokemonId) {
    _favoritePokemonsCacheStore.addListener(() {
      _favoritePokemonsCacheStore
          .isFavoritePokemon(pokemonId)
          .then(_updateState);
    });
    _stateStreamController = StreamController.broadcast(onListen: _updateState);
    _favoritePokemonsCacheStore.isFavoritePokemon(pokemonId).then(_updateState);
  }

  Stream<PokemonDetailsState> get stateStream => _stateStreamController.stream;

  void _updateState([bool? isFavorite]) {
    if (isFavorite != null) {
      _currentState = _currentState.copyWith(isFavorite: isFavorite);
    }
    _stateStreamController.add(_currentState);
  }

  void toggleFavoriteSate() {
    try {
      if (_currentState.isFavorite) {
        _favoritePokemonsCacheStore.removePokemonFromFavorites(pokemonId);
      } else {
        _favoritePokemonsCacheStore.addPokemonToFavorites(pokemonId);
      }
    } catch (_) {
      _currentState = _currentState.copyWith(
          error: PokemonDetailsBlocException(
        "An Error occurred while loadind data, please retry.",
      ));
      _stateStreamController.add(_currentState);
    }
  }
}

class PokemonDetailsBlocException implements Exception {
  final String message;

  PokemonDetailsBlocException(this.message);
}
