import '../../entities/pokemon.dart';
import '../http_client.dart';
import './string_utils.dart';

Pokemon pokemonfromJson(JsonObject jsonObject) {
  // TODO add comments.
  String currentStatName;
  for (JsonObject stat in jsonObject["stats"]) {
    currentStatName = stat["stat"]["name"];
    jsonObject[currentStatName] = stat["base_stat"];
  }

  return Pokemon(
    id: jsonObject["id"],
    name: (jsonObject["name"] as String).toCapitalized(),
    imageUrl: jsonObject["sprites"]["other"]["official-artwork"]
        ["front_default"],
    height: jsonObject["height"],
    weight: jsonObject["weight"],
    hp: jsonObject["hp"],
    attack: jsonObject["attack"],
    defense: jsonObject["defense"],
    specialAttack: jsonObject["special-attack"],
    specialDefense: jsonObject["special-defense"],
    speed: jsonObject["speed"],
    types: jsonObject["types"]
        .map<String>(_getFormattedTypeName)
        .toList(growable: false),
  );
}

String _getFormattedTypeName(dynamic type) {
  return (type["type"]["name"] as String).toCapitalized();
}
