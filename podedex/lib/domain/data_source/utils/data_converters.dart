import '../../entities/pokemon.dart';
import '../http_client.dart';

Pokemon pokemonfromJson(JsonObject jsonObject) {
  // TODO add comments.
  String currentStatName;
  for (JsonObject stat in jsonObject["stats"]) {
    currentStatName = stat["stat"];
    jsonObject[currentStatName] = stat["base_stat"];
  }

  return Pokemon(
    id: jsonObject["id"],
    name: jsonObject["name"],
    imageUrl: "imageUrl",
    height: jsonObject["height"],
    weight: jsonObject["weight"],
    hp: jsonObject["hp"],
    attack: jsonObject["attack"],
    defense: jsonObject["defense"],
    specialAttack: jsonObject["special-attack"],
    specialDefense: jsonObject["special-defense"],
    speed: jsonObject["speed"],
    types: jsonObject["types"].map(getFormattedTypeName),
  );
}

String getFormattedTypeName(JsonObject type) {
  return type["type"]["name"].toCapitalized();
}
