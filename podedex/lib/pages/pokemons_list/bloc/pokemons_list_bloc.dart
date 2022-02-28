import 'dart:async';

import 'package:podedex/domain/data_sources/pokemon_repository.dart';
import 'package:podedex/pages/pokemons_list/bloc/pokemons_list_state.dart';

class PokemonsListBloc {
  final PokemonRepository _pokemonsRepository;
  final bool favoritePokemonsOnly;
  final _nextPageRequests = StreamController<int>();
  late final StreamController<PokemonsListState> _pokemonsListStates;
  var _currentState = PokemonsListState.initial();
  int _pokemonsCount = -1;
  StreamSubscription? _nextPageRequestsSubscription;

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

  Sink<int> get nextPageRequestsSink => _nextPageRequests.sink;
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
        lastLoadedPageNumber: pageNumber,
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

  void dispose() {
    _nextPageRequestsSubscription?.cancel();
  }
}

class PokemonsListBlocExcpetion implements Exception {
  final String message;
  PokemonsListBlocExcpetion(this.message);

  @override
  String toString() => message;
}
