import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podedex/domain/data_sources/constant.dart';
import 'package:podedex/domain/data_sources/http_client.dart';
import 'package:podedex/domain/data_sources/pokemon_repository.dart';

import 'fakes/fake_data.dart';
import 'fakes/fake_favorite_pokemons_cache_store.dart';
import 'fakes/fake_http_client.dart';

void main() {
  final httpClient = FakeHttpClient();
  final pokemonRepository = PokemonRepository(
    httpClient,
    FakeFavoritePokemonsCacheStore(),
  );

  setUp(() {
    httpClient.resetGetCallsCount();
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

    test(
        "It should return the pokemon successfully fetched even if some request failed",
        () async {
      // When fetching the pokemon details, if some request failed, that should'nt
      // affect other requests.

      httpClient.throwException.addAll([3, 5, 9, 15]);
      const requestedPokemonCount = 20;
      final successfullRequestsCount =
          requestedPokemonCount - httpClient.throwException.length;

      final pokemons = await pokemonRepository.getPokemons(
        pageLength: requestedPokemonCount,
      );

      expect(
        pokemons.length,
        equals(successfullRequestsCount),
      );
    });

    test("It should throw An HttpException if all the request failed",
        () async {
      // Throws from the second time the [get] method of the http client is called
      // because the first one is not for fetching a pokemon details but for
      // fetching the list of partial data (i.e: list of `{name: "", url: ""}`).
      httpClient.throwException.addAll([2, 3, 4, 5]);

      expect(
        () async => pokemonRepository.getPokemons(
          pageLength: httpClient.throwException.length,
        ),
        throwsA(isA<HttpException>()),
      );
    });

    test(
        "It should send GET requests to the right URLs with the correct number of retries",
        () async {
      const pageLength = 10;
      const pageNumber = 3;

      await pokemonRepository.getPokemons(
        pageLength: pageLength,
        pageNumber: pageNumber,
      );

      final getInvocations = [];
      const offset = pageNumber * pageLength;
      for (int i = 1; i <= pageLength; i++) {
        getInvocations.add(
          httpClient.get("$pokemonEndpoint/${offset + i}", retryCount: 1),
        );
      }

      verify([
        httpClient.get(
          "$pokemonEndpoint?limit=$pageLength&offset=$offset",
          retryCount: 2,
        ),
        ...getInvocations,
      ]);
    });
  });

  group('Favorite Pokemon Requests', () {
    test("It should return the favorite pokemons", () async {
      final favoritePokemons =
          await pokemonRepository.getFavoritePokemons(pageLength: 5);
      expect(favoritePokemons.length, 5);
    });

    test("Pagination on favorite pokemons should work", () async {
      const pageLength = 10;
      const pageNumber = 3;
      final pokemons = await pokemonRepository.getFavoritePokemons(
        pageNumber: pageNumber,
        pageLength: pageLength,
      );
      expect(pokemons.first.id, equals((pageLength * pageNumber) + 1));
    });

    test("It should throw a ArgumentError", () async {
      // pageNumber related
      expect(
        () async => pokemonRepository.getFavoritePokemons(
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
        () async => pokemonRepository.getFavoritePokemons(
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

    test(
        "It should return the pokemon successfully fetched even if some request failed",
        () async {
      // When fetching the pokemon details, if some request failed, that should'nt
      // affect other requests.

      httpClient.throwException.addAll([3, 5, 9, 15]);
      const requestedPokemonCount = 20;
      final successfullRequestsCount =
          requestedPokemonCount - httpClient.throwException.length;

      final pokemons = await pokemonRepository.getFavoritePokemons(
        pageLength: requestedPokemonCount,
      );

      expect(
        pokemons.length,
        equals(successfullRequestsCount),
      );
    });

    test("It should throw An HttpException if all the request failed",
        () async {
      httpClient.throwException.addAll([1, 2, 3, 4, 5]);

      expect(
        () async => pokemonRepository.getFavoritePokemons(
          pageLength: httpClient.throwException.length,
        ),
        throwsA(isA<HttpException>()),
      );
    });

    test(
        "It should send GET requests to the right URLs with the correct number of retries",
        () async {
      const pageLength = 10;
      const pageNumber = 3;

      await pokemonRepository.getFavoritePokemons(
        pageLength: pageLength,
        pageNumber: pageNumber,
      );

      final getInvocations = [];
      const offset = pageNumber * pageLength;

      for (int i = 2; i <= pageLength; i++) {
        getInvocations.add(
          httpClient.get("$pokemonEndpoint/${offset + i}", retryCount: 1),
        );
      }

      // For some reason verify(getInvocations) is not working.
      verify([
        httpClient.get("$pokemonEndpoint/${offset + 1}", retryCount: 1),
        ...getInvocations
      ]);
    });
  });
}
