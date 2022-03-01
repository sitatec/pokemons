import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:podedex/data_sources_adapters/pokeapi_adapter.dart';
import 'package:podedex/domain/data_sources/constant.dart';
import 'package:podedex/domain/data_sources/http_client.dart';

import '../domain/data_sources/fakes/fake_data.dart';
import '../domain/data_sources/fakes/fake_http_client.dart';

void main() {
  final httpClient = FakeHttpClient();
  final pokeapiAdapter = PokeapiAdapter(httpClient);

  setUp(() {
    httpClient.throwException.clear();
    httpClient.resetGetCallsCount();
  });

  // ---------------- getPokemons() --------------- //

  test("It should return a list of Pokemons", () async {
    final pokemons = await pokeapiAdapter.getPokemons();
    expect(pokemons, isNotEmpty);
  });

  test(
      "It should convert and return the jsonObject returned by the http client",
      () async {
    final pokemons = await pokeapiAdapter.getPokemons();
    expect(
      pokemons.first.id,
      equals(fakePokemonJson["id"]),
    );
  });

  test(
      "It should send GET requests to the right URLs with the correct number of retries",
      () async {
    const pageLength = 10;
    const pageNumber = 3;

    await pokeapiAdapter.getPokemons(
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

  // ---------------- fetchPokemonsUrls() --------------- //

  test("It should fetch all the given URLs", () async {
    final pokemonsUrls = <String>[];
    for (var i = 0; i < httpClient.throwException.length; i++) {
      pokemonsUrls.add("$pokemonEndpoint/$i");
    }
    final pokemons = await pokeapiAdapter.fetchPokemonsUrls(pokemonsUrls);
    expect(pokemons.length, pokemonsUrls.length);
  });

  test(
      "It should return the pokemon successfully fetched even if some request failed",
      () async {
    httpClient.throwException.addAll([3, 5, 9, 15]);
    const requestedPokemonCount = 20;
    final successfullRequestsCount =
        requestedPokemonCount - httpClient.throwException.length;
    final pokemonsUrls = <String>[];
    for (var i = 0; i < requestedPokemonCount; i++) {
      pokemonsUrls.add("$pokemonEndpoint/$i");
    }
    final pokemons = await pokeapiAdapter.fetchPokemonsUrls(pokemonsUrls);

    expect(
      pokemons.length,
      equals(successfullRequestsCount),
    );
  });

  test("It should throw An HttpException if all the request failed", () async {
    httpClient.throwException.addAll([1, 2, 3, 4, 5]);
    final pokemonsUrls = <String>[];
    for (var i = 0; i < httpClient.throwException.length; i++) {
      pokemonsUrls.add("$pokemonEndpoint/$i");
    }
    expect(
      () async => pokeapiAdapter.fetchPokemonsUrls(pokemonsUrls),
      throwsA(isA<HttpException>()),
    );
  });

  test(
      "fetchPokemonsUrls should send GET requests to the right URLs with the correct number of retries",
      () async {
    final pokemonsUrls = <String>[];
    String currentUrl;
    final getInvocations = [];
    for (var i = 0; i < 5; i++) {
      currentUrl = "$pokemonEndpoint/$i";
      pokemonsUrls.add(currentUrl);
      getInvocations.add(httpClient.get(currentUrl, retryCount: 1));
    }

    await pokeapiAdapter.fetchPokemonsUrls(pokemonsUrls);

    verify([
      httpClient.get(
        pokemonsUrls.first,
        retryCount: 1,
      ),
      ...getInvocations..removeAt(0),
    ]);
  });
}
