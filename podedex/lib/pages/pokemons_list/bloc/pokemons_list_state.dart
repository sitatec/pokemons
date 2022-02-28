import 'package:podedex/domain/entities/pokemon.dart';
import 'package:podedex/pages/pokemons_list/bloc/pokemons_list_bloc.dart';

class PokemonsListState {
  final bool lastPageLoaded;
  final List<Pokemon> pokemonsList;
  final PokemonsListBlocExcpetion? error;
  final int lastLoadedPageNumber;

  PokemonsListState({
    required this.pokemonsList,
    required this.lastLoadedPageNumber,
    this.lastPageLoaded = false,
    this.error,
  });

  PokemonsListState.initial()
      : this(pokemonsList: [], lastLoadedPageNumber: -1);

  PokemonsListState copyWith({
    bool? lastPageLoaded,
    List<Pokemon>? pokemonsList,
    PokemonsListBlocExcpetion? error,
    int? lastLoadedPageNumber,
  }) =>
      PokemonsListState(
        lastPageLoaded: lastPageLoaded ?? this.lastPageLoaded,
        pokemonsList: pokemonsList ?? this.pokemonsList,
        error: error ?? this.error,
        lastLoadedPageNumber: lastLoadedPageNumber ?? this.lastLoadedPageNumber,
      );

  void dispose() {
    pokemonsList.clear();
  }
}
