import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/domain/data_sources/http_client.dart';
import 'package:podedex/domain/data_sources/pokemon_repository.dart';

import 'fakes/fake_data.dart';
import 'fakes/fake_favorite_pokemons_cache_store.dart';
import 'fakes/fake_pokemons_remote_data_sources.dart';

void main() {
  final pokemonsRemoteDataSource = FakePokemonsRemoteDataSource();
  final fakeFavoritePokemonsCacheStore = FakeFavoritePokemonsCacheStore();
  final pokemonRepository = PokemonRepository(
    pokemonsRemoteDataSource,
    fakeFavoritePokemonsCacheStore,
  );

  setUp(() {
    pokemonsRemoteDataSource.exception = null;
    // Do not throw exception on methods c.
  });

  group("Pokemon Requests: ", () {
    test("It should return a list of Pokemons", () async {
      final pokemons = await pokemonRepository.getPokemons();
      expect(pokemons, isNotEmpty);
    });

    test(
        "It should convert and return the jsonObject returned by the http client",
        () async {
      final pokemons = await pokemonRepository.getPokemons();
      expect(
        pokemons.first.id,
        equals(fakePokemonJson["id"]),
      );
    });

    test("It should return pokemons for the given page", () async {
      const pageLength = 20;
      const pageNumber = 3;
      final pokemons = await pokemonRepository.getPokemons(
        pageNumber: pageNumber,
        pageLength: pageLength,
      );
      expect(pokemons.first.id, equals((pageLength * pageNumber) + 1));
    });

    test("It should throw a ArgumentError", () async {
      // pageNumber related
      expect(
        () async => pokemonRepository.getPokemons(
          pageNumber: -1, // Can't be negative.
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.name,
            "argument name",
            "pageNumber",
          ),
        ),
      );
      // pageLength related
      expect(
        () async => pokemonRepository.getPokemons(
          // Required 1 or higher (should request at least one pokemon).
          pageLength: 0,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.name,
            "argument name",
            "pageLength",
          ),
        ),
      );
    });

    test("It should throw and HttpException", () {
      final exception = HttpException(statusCode: 500, message: "message");
      // tell the fake remode data source to throw an exception on the next method call.
      pokemonsRemoteDataSource.exception = exception;

      expect(
        () async => pokemonRepository.getPokemons(),
        throwsA(
          isA<HttpException>()
              .having(
                (error) => error.message,
                "message",
                equals(exception.message),
              )
              .having(
                (error) => error.statusCode,
                "status code",
                equals(exception.statusCode),
              ),
        ),
      );
    });

    test("It should return the number of all the pokemons", () async {
      expect(
        await pokemonRepository.getPokemonsCount(),
        equals(await pokemonsRemoteDataSource.allPokemonsCount),
      );
    });

    test("It should return the number of all the FAVORITE pokemons", () async {
      expect(
        await pokemonRepository.getPokemonsCount(favoritesOnly: true),
        equals(await fakeFavoritePokemonsCacheStore.favoritePokemonsCount),
      );
    });
  });

  group('Favorite Pokemon Requests', () {
    test("It should return the favorite pokemons", () async {
      final favoritePokemons = await pokemonRepository.getPokemons(
          pageLength: 5, favoritesOnly: true);
      expect(favoritePokemons.length, 5);
    });

    test("Pagination on favorite pokemons should work", () async {
      const pageLength = 10;
      const pageNumber = 3;
      final pokemons = await pokemonRepository.getPokemons(
        pageNumber: pageNumber,
        pageLength: pageLength,
        favoritesOnly: true,
      );
      expect(pokemons.first.id, equals((pageLength * pageNumber) + 1));
    });

    test("It should throw a ArgumentError", () async {
      // pageNumber related
      expect(
        () async => pokemonRepository.getPokemons(
          pageNumber: -1, // Can't be negative.
          favoritesOnly: true,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.name,
            "argument name",
            "pageNumber",
          ),
        ),
      );
      // pageLength related
      expect(
        () async => pokemonRepository.getPokemons(
          // Required 1 or higher (should request at least one pokemon).
          pageLength: 0,
          favoritesOnly: true,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.name,
            "argument name",
            "pageLength",
          ),
        ),
      );
    });
  });
}
