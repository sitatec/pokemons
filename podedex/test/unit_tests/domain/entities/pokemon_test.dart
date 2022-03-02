import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/domain/entities/pokemon.dart';

void main() {
  const pokemonHeight = 8;
  const pokemonWeight = 19;
  const pokemonHp = 39;
  const pokemonAttack = 29;
  const pokemonDefense = 30;
  const pokemonApecialAttack = 19;
  const pokemonApecialDefense = 11;
  const pokemonSpeed = 22;

  test("It should return the right BMI value", () {
    final pokemon = Pokemon(
      id: 3,
      name: "name",
      imageUrl: "imageUrl",
      height: pokemonHeight,
      weight: pokemonWeight,
      hp: pokemonHp,
      attack: pokemonAttack,
      defense: pokemonDefense,
      specialAttack: pokemonApecialAttack,
      specialDefense: pokemonApecialDefense,
      speed: pokemonSpeed,
      types: [],
    );

    expect(pokemon.bmi, pokemonWeight / (pokemonHeight ^ 2));
  });

  test("It should return the right average power of the pokemon", () {
    final pokemon = Pokemon(
      id: 3,
      name: "name",
      imageUrl: "imageUrl",
      height: pokemonHeight,
      weight: pokemonWeight,
      hp: pokemonHp,
      attack: pokemonAttack,
      defense: pokemonDefense,
      specialAttack: pokemonApecialAttack,
      specialDefense: pokemonApecialDefense,
      speed: pokemonSpeed,
      types: [],
    );

    const statsSum = pokemonHp +
        pokemonAttack +
        pokemonDefense +
        pokemonApecialAttack +
        pokemonApecialDefense +
        pokemonSpeed;

    expect(pokemon.avgPower, statsSum / 6);
  });

  test("It should correctly format the pokemon's one digit ID", () {
    final pokemon = Pokemon(
      id: 3,
      name: "name",
      imageUrl: "imageUrl",
      height: pokemonHeight,
      weight: pokemonWeight,
      hp: pokemonHp,
      attack: pokemonAttack,
      defense: pokemonDefense,
      specialAttack: pokemonApecialAttack,
      specialDefense: pokemonApecialDefense,
      speed: pokemonSpeed,
      types: [],
    );

    expect(pokemon.formatedId, "#003");
  });

  test("It should correctly format the pokemon's two digit ID", () {
    final pokemon = Pokemon(
      id: 54,
      name: "name",
      imageUrl: "imageUrl",
      height: pokemonHeight,
      weight: pokemonWeight,
      hp: pokemonHp,
      attack: pokemonAttack,
      defense: pokemonDefense,
      specialAttack: pokemonApecialAttack,
      specialDefense: pokemonApecialDefense,
      speed: pokemonSpeed,
      types: [],
    );

    expect(pokemon.formatedId, "#054");
  });

  test("It should correctly format the pokemon's three digit ID", () {
    final pokemon = Pokemon(
      id: 492,
      name: "name",
      imageUrl: "imageUrl",
      height: pokemonHeight,
      weight: pokemonWeight,
      hp: pokemonHp,
      attack: pokemonAttack,
      defense: pokemonDefense,
      specialAttack: pokemonApecialAttack,
      specialDefense: pokemonApecialDefense,
      speed: pokemonSpeed,
      types: [],
    );

    expect(pokemon.formatedId, "#492");
  });
}
