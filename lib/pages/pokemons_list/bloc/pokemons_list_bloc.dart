import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../../../domain/data_sources/favorite_pokemons_cache_store.dart';

import '../../../domain/data_sources/pokemon_repository.dart';
import 'pokemons_list_state.dart';

/// The `BLOC` of the [PokemonsList] widget.
class PokemonsListBloc {
  final PokemonRepository _pokemonsRepository;
  final _nextPageRequests = StreamController<int>();
  late final StreamController<PokemonsListState> _pokemonsListStates;
  var currentState = PokemonsListState.initial();
  int _pokemonsCount = -1;
  StreamSubscription? _nextPageRequestsSubscription;
  final _onDisposeListeners = <VoidCallback>[];

  /// Whether this `BLOC` allow interaction with **only** the favorite pokemons
  /// or not.
  late final bool favoritePokemonsOnly;

  /// Create a [PokemonsListBloc].
  PokemonsListBloc(this._pokemonsRepository,
      [FavoritePokemonsCacheStore? favoritePokemonsStore]) {
    favoritePokemonsOnly = favoritePokemonsStore != null;
    _getPokemonsCount();
    favoritePokemonsStore?.addListener(() {
      _getPokemonsCount(true);
      currentState = PokemonsListState.initial();
      _fetchNextPage(0);
    });
    _nextPageRequestsSubscription =
        _nextPageRequests.stream.listen(_fetchNextPage);
    _pokemonsListStates = StreamController<PokemonsListState>.broadcast(
      onListen: () => _pokemonsListStates.add(currentState),
    );
  }

  FutureOr<int> _getPokemonsCount([bool refresh = false]) async {
    if (_pokemonsCount == -1 || refresh) {
      _pokemonsCount = await _pokemonsRepository.getPokemonsCount(
        favoritesOnly: favoritePokemonsOnly,
      );
    }
    return _pokemonsCount;
  }

  /// The Sink where the [PokemonsList] widget can add events for loading the
  /// next page.
  Sink<int> get nextPageRequestsSink => _nextPageRequests.sink;

  /// A Stream of [PokemonsListState]
  ///
  /// The [PokemonsList] widget can listen to this stream and update its state
  /// whenever a new state is pushed to the stream.
  Stream<PokemonsListState> get pokemonsListStatesStream =>
      _pokemonsListStates.stream;

  Future<void> _fetchNextPage(int pageNumber) async {
    try {
      final newPokemons = await _pokemonsRepository.getPokemons(
        pageNumber: pageNumber,
        favoritesOnly: favoritePokemonsOnly,
      );
      currentState = currentState.copyWith(
        pokemonsList: currentState.pokemonsList + newPokemons,
        currentPageNumber: pageNumber,
        lastPageLoaded:
            currentState.pokemonsList.length >= await _getPokemonsCount(),
      );
    } catch (error) {
      currentState = currentState.copyWith(
          error: PokemonsListBlocExcpetion(
        "An Error occurred while loadind data, please retry.",
      ));
    } finally {
      _pokemonsListStates.add(currentState);
    }
  }

  /// Free any ressource held by this BLOC e.g: Streams
  void dispose() {
    _nextPageRequestsSubscription?.cancel();
    currentState.dispose();
    for (var disposeListener in _onDisposeListeners) {
      disposeListener();
    }
  }

  void addOndisposeListener(VoidCallback listener) =>
      _onDisposeListeners.add(listener);
}

/// Thrown when a error occured while loading data
class PokemonsListBlocExcpetion implements Exception {
  /// The error message
  final String message;
  PokemonsListBlocExcpetion(this.message);

  @override
  String toString() => message;
}
