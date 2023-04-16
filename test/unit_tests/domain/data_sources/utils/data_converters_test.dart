import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/domain/data_sources/http_client.dart';
import 'package:podedex/domain/data_sources/utils/data_converters.dart';
import 'package:podedex/domain/data_sources/utils/string_utils.dart';
import 'package:podedex/domain/entities/pokemon.dart';

import '../fakes/fake_data.dart';

void main() {
  test("It should convert the jsonObject to a Pokemon object", () {
    expect(pokemonfromJson(newFakePokemonJson), isA<Pokemon>());
  });

  test("It should correctlly format the Pokemon's name", () {
    final pokemon = pokemonfromJson(newFakePokemonJson);
    expect(
      pokemon.name,
      (newFakePokemonJson["name"] as String).toCapitalized(),
    );
  });

  test("It should correctlly format the Pokemon's type names", () {
    final pokemon = pokemonfromJson(newFakePokemonJson);
    final typesJson = List.from(
      newFakePokemonJson["types"],
      growable: false,
    );

    for (int i = 0; i < pokemon.types.length; i++) {
      expect(
        pokemon.types[i],
        _extractTypeName(typesJson[i]).toCapitalized(),
      );
    }
  });
}

String _extractTypeName(JsonObject type) => type["type"]["name"];
