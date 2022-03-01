import 'pokemon_details_bloc.dart';
import '../pokemon_details_page.dart';

class PokemonDetailsState {
  final bool isFavorite;
  final PokemonDetailsBlocException? error;

  PokemonDetailsState(this.isFavorite, [this.error]);

  PokemonDetailsState.initial() : this(false);

  PokemonDetailsState copyWith({
    bool? isFavorite,
    PokemonDetailsBlocException? error,
  }) =>
      PokemonDetailsState(isFavorite ?? this.isFavorite, error);
}
