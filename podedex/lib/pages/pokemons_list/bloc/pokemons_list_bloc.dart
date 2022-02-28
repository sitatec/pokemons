import 'dart:async';

import '../../../domain/data_sources/pokemon_repository.dart';
import 'pokemons_list_state.dart';

/// The `BLOC` of the [PokemonsList] widget.
class PokemonsListBloc {
  final PokemonRepository _pokemonsRepository;
  final _nextPageRequests = StreamController<int>();
  late final StreamController<PokemonsListState> _pokemonsListStates;
  var _currentState = PokemonsListState.initial();
  int _pokemonsCount = -1;
  StreamSubscription? _nextPageRequestsSubscription;

  /// Whether this `BLOC` allow interaction with **only** the favorite pokemons
  /// or not.
  final bool favoritePokemonsOnly;

  /// Create a [PokemonsListBloc].
  PokemonsListBloc(
    this._pokemonsRepository, {
    this.favoritePokemonsOnly = false,
  }) {
    _getPokemonsCount();
    _nextPageRequestsSubscription =
        _nextPageRequests.stream.listen(_fetchNextPage);
    _pokemonsListStates = StreamController<PokemonsListState>.broadcast(
      onListen: () => _pokemonsListStates.add(_currentState),
    );
  }

  FutureOr<int> _getPokemonsCount() async {
    if (_pokemonsCount == -1) {
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
      _currentState = _currentState.copyWith(
        pokemonsList: _currentState.pokemonsList + newPokemons,
        currentPageNumber: pageNumber,
        lastPageLoaded:
            _currentState.pokemonsList.length == _getPokemonsCount(),
      );
    } catch (error) {
      _currentState = _currentState.copyWith(
          error: PokemonsListBlocExcpetion(
        "An Error occurred while loadind data, please retry.",
      ));
    } finally {
      _pokemonsListStates.add(_currentState);
    }
  }

  /// Free any ressource held by this BLOC e.g: Streams
  void dispose() {
    _nextPageRequestsSubscription?.cancel();
    _currentState.dispose();
  }
}

/// Thrown when a error occured while loading data
class PokemonsListBlocExcpetion implements Exception {
  /// The error message
  final String message;
  PokemonsListBlocExcpetion(this.message);

  @override
  String toString() => message;
}
