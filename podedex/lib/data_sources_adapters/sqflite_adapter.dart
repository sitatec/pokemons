import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:podedex/domain/data_sources/favorite_pokemons_cache_store.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteAdapter implements FavoritePokemonsCacheStore {
  late final FutureOr<Database> _database;
  @visibleForTesting
  static const tableName = "favorite_pokemons";

  SqfliteAdapter(Database? database) {
    if (database != null) {
      _database = database;
    } else {
      _initializeDatabase();
    }
  }

  Future<void> _initializeDatabase() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'favorite_pokemons.db'),
      onCreate: _createFavoritePokemonsTable,
      version: 1,
    );
  }

  FutureOr<void> _createFavoritePokemonsTable(
    Database database,
    int databaseVersion,
  ) {
    return _handleDatabaseError<void>(() async {
      return database.execute(
        "CREATE TABLE $tableName (id INTEGER NOT NULL PRIMARY KEY)",
      );
    });
  }

  @override
  Future<int> get favoritePokemonsCount async {
    return _handleDatabaseError<int>(() async {
      final database = await _database;
      final databaseResponse =
          await database.rawQuery("SELECT COUNT(*) FROM $tableName");
      return Sqflite.firstIntValue(databaseResponse)!;
    });
  }

  @override
  Future<void> addPokemonToFavorites(int pokemonId) async {
    return _handleDatabaseError<void>(() async {
      final database = await _database;
      await database.insert(
        tableName,
        {"id": pokemonId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<List<int>> getFavoritePokemonIds({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    return _handleDatabaseError<List<int>>(() async {
      final database = await _database;
      final favoritePokemonsIds = await database.query(
        tableName,
        limit: pageLength,
        offset: pageLength * pageNumber,
      );
      return favoritePokemonsIds
          .map((favoritePokemonsRow) => favoritePokemonsRow["id"] as int)
          .toList(growable: false);
    });
  }

  @override
  Future<void> removePokemonFromFavorites(int pokemonId) async {
    return _handleDatabaseError<void>(() async {
      final database = await _database;
      await database.delete(tableName, where: "id = ?", whereArgs: [pokemonId]);
    });
  }

  Future<T> _handleDatabaseError<T>(Future<T> Function() function) async {
    try {
      return await function();
    } on DatabaseException catch (error) {
      throw FavoritePokemonsCacheException(error.toString());
    }
  }
}
