import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_commands.dart';
import 'model/tag.dart';

class DatabaseApp {
  // Open the database and store the reference.
  Future<Database> database;

  //Constructor
//  DatabaseApp() {
//    database = getDatabase();
//  }

  Future<Database> getDatabase() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'zennote_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        //await db.execute(CREATE_TABLE_NOTE);
        //await db.execute(CREATE_TABLE_NOTE_ITEM);
//        await db.execute(DROP_TABLE_TAG);
        await db.execute(CREATE_TABLE_TAG);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

}
