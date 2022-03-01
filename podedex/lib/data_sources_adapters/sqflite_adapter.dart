import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import '../domain/data_sources/favorite_pokemons_cache_store.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteAdapter extends ChangeNotifier
    implements FavoritePokemonsCacheStore {
  late final Database _database;
  @visibleForTesting
  static const tableName = "favorite_pokemons";
  final _databaseInitialized = Completer<bool>();

  SqfliteAdapter([Database? database]) {
    if (database != null) {
      _database = database;
    } else {
      _initializeDatabase();
    }
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'favorite_pokemons.db'),
      onCreate: _createFavoritePokemonsTable,
      version: 1,
    );
    _databaseInitialized.complete(true);
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
      await _databaseInitialized.future;
      final databaseResponse =
          await _database.rawQuery("SELECT COUNT(*) FROM $tableName");
      return Sqflite.firstIntValue(databaseResponse)!;
    });
  }

  @override
  Future<void> addPokemonToFavorites(int pokemonId) async {
    return _handleDatabaseError<void>(() async {
      await _databaseInitialized.future;
      await _database.insert(
        tableName,
        {"id": pokemonId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      notifyListeners();
    });
  }

  @override
  Future<bool> isFavoritePokemon(int pokemonId) {
    return _handleDatabaseError<bool>(() async {
      await _databaseInitialized.future;
      final databaseResponse = await _database.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM $tableName WHERE id = ?)",
        [pokemonId],
      );
      return Sqflite.firstIntValue(databaseResponse) == 1;
    });
  }

  @override
  Future<List<int>> getFavoritePokemonIds({
    int pageNumber = 0,
    int pageLength = 30,
  }) async {
    return _handleDatabaseError<List<int>>(() async {
      await _databaseInitialized.future;
      final favoritePokemonsIds = await _database.query(
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
      await _databaseInitialized.future;
      await _database
          .delete(tableName, where: "id = ?", whereArgs: [pokemonId]);
      notifyListeners();
    });
  }

  @override
  Future<void> dispose() async {
    await _handleDatabaseError<void>(() async {
      await _databaseInitialized.future;
      return _database.close();
    });
    super.dispose();
  }

  Future<T> _handleDatabaseError<T>(Future<T> Function() function) async {
    try {
      return await function();
    } on DatabaseException catch (error) {
      throw FavoritePokemonsCacheException(error.toString());
    }
  }
}
