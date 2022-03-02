import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/domain/data_sources/favorite_pokemons_cache_store.dart';
import 'package:podedex/pages/pokemon_details/bloc/pokemon_details_bloc.dart';

import '../domain/data_sources/fakes/fake_favorite_pokemons_cache_store.dart';

void main() {
  final fakeFavoritePokemonsCache = FakeFavoritePokemonsCacheStore();
  const pokemonId = 22;
  late PokemonDetailsBloc pokemonDetailsBloc;

  setUp(() {
    pokemonDetailsBloc = PokemonDetailsBloc(
      fakeFavoritePokemonsCache,
      pokemonId,
    );
  });

  test("Should toggle favorite's state | initially true", () async {
    fakeFavoritePokemonsCache.isFavorite = true;
    // Wait until the listeners have been notified.
    await Future.delayed(Duration.zero);
    pokemonDetailsBloc.toggleFavoriteSate();
    // Wait until the listeners have been notified.
    await Future.delayed(Duration.zero);
    expect(fakeFavoritePokemonsCache.isFavorite, isFalse);
  });

  test("Should toggle favorite's state | initially false", () async {
    fakeFavoritePokemonsCache.isFavorite = false;
    // Wait until the listeners have been notified.
    await Future.delayed(Duration.zero);
    pokemonDetailsBloc.toggleFavoriteSate();
    // Wait until the listeners have been notified.
    await Future.delayed(Duration.zero);
    expect(fakeFavoritePokemonsCache.isFavorite, isTrue);
  });

  test("New state should contain PokemonDetailsBlocException", () async {
    fakeFavoritePokemonsCache.exception =
        FavoritePokemonsCacheException("message");
    pokemonDetailsBloc.toggleFavoriteSate();
    // Wait until the listeners have been notified.
    await Future.delayed(Duration.zero);
    final newState = await pokemonDetailsBloc.stateStream.first;
    expect(newState.error, isA<PokemonDetailsBlocException>());
  });
}
