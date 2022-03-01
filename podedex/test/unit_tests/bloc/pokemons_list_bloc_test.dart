import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:podedex/domain/data_sources/http_client.dart';
import 'package:podedex/domain/data_sources/pokemon_repository.dart';
import 'package:podedex/domain/data_sources/utils/data_converters.dart';
import 'package:podedex/pages/pokemons_list/bloc/pokemons_list_bloc.dart';

import '../domain/data_sources/fakes/fake_data.dart';
import '../domain/data_sources/fakes/fake_favorite_pokemons_cache_store.dart';
import 'pokemons_list_bloc_test.mocks.dart';

@GenerateMocks([PokemonRepository])
void main() {
  final mockPokemonRepository = MockPokemonRepository();
  final fakeFavoritePokemonsCache = FakeFavoritePokemonsCacheStore();
  late final PokemonsListBloc pokemonsListBloc;

  setUpAll(() {
    when(mockPokemonRepository.getPokemonsCount()).thenAnswer((_) async => 4);
    pokemonsListBloc = PokemonsListBloc(mockPokemonRepository);
  });
  test('It should not be favorite only', () {
    final pokemonsListBlock = PokemonsListBloc(mockPokemonRepository);
    expect(pokemonsListBlock.favoritePokemonsOnly, false);
  });

  test('It should be favorite only', () {
    when(mockPokemonRepository.getPokemonsCount(favoritesOnly: true))
        .thenAnswer((_) async => 4);
    final pokemonsListBlock =
        PokemonsListBloc(mockPokemonRepository, fakeFavoritePokemonsCache);
    expect(pokemonsListBlock.favoritePokemonsOnly, true);
  });

  test("It should respond next page request", () async {
    const pageNumber = 4;
    final page = [pokemonfromJson(newFakePokemonJson)];
    when(mockPokemonRepository.getPokemons(pageNumber: pageNumber)).thenAnswer(
      (_) async => page,
    );
    pokemonsListBloc.nextPageRequestsSink.add(pageNumber);

    // Wait until the state have been updated by the BLOC.
    await Future.delayed(Duration.zero);

    final newState = await pokemonsListBloc.pokemonsListStatesStream.first;
    expect(newState.pokemonsList, equals(page));
  });

  test("The new state should contain a PokemonsListBlocExcpetion", () async {
    const pageNumber = 4;
    when(mockPokemonRepository.getPokemons(pageNumber: pageNumber))
        .thenThrow(HttpException(statusCode: 500, message: "message"));

    pokemonsListBloc.nextPageRequestsSink.add(pageNumber);
    // Wait until the state have been updated by the BLOC.
    await Future.delayed(Duration.zero);
    final newState = await pokemonsListBloc.pokemonsListStatesStream.first;

    expect(newState.error, isA<PokemonsListBlocExcpetion>());
  });

  test("Should dispose", () async {
    bool disposed = false;
    pokemonsListBloc.addOndisposeListener(() => disposed = true);
    pokemonsListBloc.dispose();
    expect(disposed, isTrue);
  });
}
