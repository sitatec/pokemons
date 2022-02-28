import '../../../domain/entities/pokemon.dart';
import 'pokemons_list_bloc.dart';

/// Represents a single state of the [PokemonsList] widget.
class PokemonsListState {
  /// Whether the last page of the pokemons list have been loaded or not
  /// i.e No more data to load.
  final bool lastPageLoaded;

  /// Hold all the Pokemons previously loaded.
  ///
  /// TODO optimize memory usage
  final List<Pokemon> pokemonsList;

  /// The error occurred while loading the current page. Is null if no error occurred.
  final PokemonsListBlocExcpetion? error;

  /// The current page number.
  final int currentPageNumber;

  PokemonsListState({
    required this.pokemonsList,
    required this.currentPageNumber,
    this.lastPageLoaded = false,
    this.error,
  });

  PokemonsListState.initial() : this(pokemonsList: [], currentPageNumber: -1);

  PokemonsListState copyWith({
    bool? lastPageLoaded,
    List<Pokemon>? pokemonsList,
    PokemonsListBlocExcpetion? error,
    int? currentPageNumber,
  }) =>
      PokemonsListState(
        lastPageLoaded: lastPageLoaded ?? this.lastPageLoaded,
        pokemonsList: pokemonsList ?? this.pokemonsList,
        error: error ?? this.error,
        currentPageNumber: currentPageNumber ?? this.currentPageNumber,
      );

  /// Free any ressource held by this state.
  void dispose() {
    pokemonsList.clear();
  }
}
