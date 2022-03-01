import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:podedex/data_sources_adapters/sqflite_adapter.dart';
import 'package:podedex/domain/data_sources/favorite_pokemons_cache_store.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflite_adapter_test.mocks.dart';

@GenerateMocks([Database, DatabaseException])
void main() {
  final mockDatabase = MockDatabase();
  final sqfliteAdapter = SqfliteAdapter(mockDatabase);
  final mockDatabaseException = MockDatabaseException();
  const pokemonId = 23;

  // ----------------- get favoritePokemonsCount ---------------- //

  test("It should return the favorite pokemons count", () async {
    const favoritePokemonsCount = 33;
    when(
      mockDatabase.rawQuery("SELECT COUNT(*) FROM ${SqfliteAdapter.tableName}"),
    ).thenAnswer((_) async => [
          {"COUNT(*)": favoritePokemonsCount}
        ]);

    expect(
      await sqfliteAdapter.favoritePokemonsCount,
      equals(favoritePokemonsCount),
    );
  });

  test(
      "It should throw FavoritePokemonsCacheException when trying to access favoritePokemonsCount",
      () async {
    when(
      mockDatabase.rawQuery("SELECT COUNT(*) FROM ${SqfliteAdapter.tableName}"),
    ).thenThrow(mockDatabaseException);

    expect(
      () async => await sqfliteAdapter.favoritePokemonsCount,
      throwsA(
        isA<FavoritePokemonsCacheException>().having(
          (error) => error.message,
          "error message",
          equals(mockDatabaseException.toString()),
        ),
      ),
    );
  });

  // ----------------- addPokemonToFavorites ---------------- //

  test("It shoud add a pokemon to the favorites", () async {
    when(
      mockDatabase.insert(
        SqfliteAdapter.tableName,
        {"id": pokemonId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenAnswer((_) async => pokemonId);

    await sqfliteAdapter.addPokemonToFavorites(pokemonId);

    verify(
      await mockDatabase.insert(
        SqfliteAdapter.tableName,
        {"id": pokemonId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    );
  });

  test(
      "It should throw FavoritePokemonsCacheException when trying to add a pokemon to the favorites",
      () async {
    when(
      mockDatabase.insert(
        SqfliteAdapter.tableName,
        {"id": pokemonId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      ),
    ).thenThrow(mockDatabaseException);

    expect(
      () async => await sqfliteAdapter.addPokemonToFavorites(pokemonId),
      throwsA(
        isA<FavoritePokemonsCacheException>().having(
          (error) => error.message,
          "error message",
          equals(mockDatabaseException.toString()),
        ),
      ),
    );
  });

  // ----------------- getFavoritePokemonIds ---------------- //

  test("It should get Favorite Pokemon Ids", () async {
    const favoritePokemonsIds = [
      {"id": 1},
      {"id": 14},
      {"id": 51},
      {"id": 33},
      {"id": 80},
    ];
    const pageLength = 10;
    const pageNumber = 3;

    when(
      mockDatabase.query(
        SqfliteAdapter.tableName,
        limit: pageLength,
        offset: pageLength * pageNumber,
      ),
    ).thenAnswer((_) async => favoritePokemonsIds);

    expect(
      await sqfliteAdapter.getFavoritePokemonIds(
        pageLength: pageLength,
        pageNumber: pageNumber,
      ),
      equals(
        favoritePokemonsIds
            .map((favoritePokemonsRow) => favoritePokemonsRow["id"] as int)
            .toList(growable: false),
      ),
    );

    verify(
      mockDatabase.query(
        SqfliteAdapter.tableName,
        limit: pageLength,
        offset: pageLength * pageNumber,
      ),
    );
  });

  test(
      "It should throw FavoritePokemonsCacheException when trying to get Favorite Pokemon Ids",
      () async {
    const pageLength = 10;
    const pageNumber = 3;
    when(
      mockDatabase.query(
        SqfliteAdapter.tableName,
        limit: pageLength,
        offset: pageLength * pageNumber,
      ),
    ).thenThrow(mockDatabaseException);

    expect(
      () async => await sqfliteAdapter.getFavoritePokemonIds(
        pageLength: pageLength,
        pageNumber: pageNumber,
      ),
      throwsA(
        isA<FavoritePokemonsCacheException>().having(
          (error) => error.message,
          "error message",
          equals(mockDatabaseException.toString()),
        ),
      ),
    );
  });

  // ----------------- removePokemonFromFavorites ---------------- //

  test("It shoud remove a pokemon from favorites", () async {
    when(
      mockDatabase.delete(
        SqfliteAdapter.tableName,
        where: "id = ?",
        whereArgs: [pokemonId],
      ),
    ).thenAnswer((_) async => pokemonId);

    await sqfliteAdapter.removePokemonFromFavorites(pokemonId);

    verify(
      await mockDatabase.delete(
        SqfliteAdapter.tableName,
        where: "id = ?",
        whereArgs: [pokemonId],
      ),
    );
  });

  test(
      "It should throw FavoritePokemonsCacheException when trying to remove a pokemon from the favorites",
      () async {
    when(
      mockDatabase.delete(
        SqfliteAdapter.tableName,
        where: "id = ?",
        whereArgs: [pokemonId],
      ),
    ).thenThrow(mockDatabaseException);

    expect(
      () async => await sqfliteAdapter.removePokemonFromFavorites(pokemonId),
      throwsA(
        isA<FavoritePokemonsCacheException>().having(
          (error) => error.message,
          "error message",
          equals(mockDatabaseException.toString()),
        ),
      ),
    );
  });

  // ----------------- isFavoritePokemon ---------------- //

  test("It shoud return true (the pokemon is a favorite one)", () async {
    when(
      mockDatabase.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM ${SqfliteAdapter.tableName} WHERE id = ?)",
        [pokemonId],
      ),
    ).thenAnswer((_) async => [
          {"": 1} // 1 ==> true
        ]);

    expect(
      await sqfliteAdapter.isFavoritePokemon(pokemonId),
      equals(true),
    );
  });

  test("It shoud return false (the pokemon is not a favorite one)", () async {
    when(
      mockDatabase.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM ${SqfliteAdapter.tableName} WHERE id = ?)",
        [pokemonId],
      ),
    ).thenAnswer((_) async => [
          {"": 0} // 0 ==> true
        ]);

    expect(
      await sqfliteAdapter.isFavoritePokemon(pokemonId),
      equals(false),
    );
  });

  test(
      "It should throw FavoritePokemonsCacheException when checkin if the pokemon is favorite",
      () async {
    when(
      mockDatabase.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM ${SqfliteAdapter.tableName} WHERE id = ?)",
        [pokemonId],
      ),
    ).thenThrow(mockDatabaseException);

    expect(
      () async => await sqfliteAdapter.isFavoritePokemon(pokemonId),
      throwsA(
        isA<FavoritePokemonsCacheException>().having(
          (error) => error.message,
          "error message",
          equals(mockDatabaseException.toString()),
        ),
      ),
    );
  });

  // ----------------- dispose ---------------- //

  test("It shoud dispose all the ressources used by SqfliteAdapter", () async {
    when(
      mockDatabase.close(),
    ).thenAnswer((_) async {});

    await sqfliteAdapter.dispose();

    verify(await mockDatabase.close());
  });

  test(
      "It should throw FavoritePokemonsCacheException when trying to dispose ressources",
      () async {
    when(mockDatabase.close()).thenThrow(mockDatabaseException);

    expect(
      () async => await sqfliteAdapter.dispose(),
      throwsA(
        isA<FavoritePokemonsCacheException>().having(
          (error) => error.message,
          "error message",
          equals(mockDatabaseException.toString()),
        ),
      ),
    );
  });
}
