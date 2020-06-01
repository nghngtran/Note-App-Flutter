import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../db_commands.dart';
import '../model/tag.dart';

class DatabaseApp {
  // Open the database and store the reference.
//  static Future<Database> database ;
  static final DatabaseApp dbProvider = DatabaseApp();
  Database _database;

  //Constructor
//  DatabaseApp() {
//    database = getDatabase();
//  }
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }
  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance named
    String path = join(documentsDirectory.path, "RekdcccasdkkdddsafctivdedTodos12.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }
  void initDB(Database database, int version) async {
    await database.execute(DROP_TABLE_NOTE);
    await database.execute(DROP_TABLE_TAG);
    await database.execute(DROP_TABLE_NOTE_ITEM);
    await database.execute(DROP_TABLE_RELATIVE);
    await database.execute(DROP_TABLE_THUMBNAIL);

    await database.execute(CREATE_TABLE_TAG);
    await database.execute(CREATE_TABLE_THUMBNAIL_NOTE);
    await database.execute(CREATE_TABLE_NOTE_ITEM);
    await database.execute(CREATE_TABLE_NOTE);
    await database.execute(CREATE_TABLE_RELATIVE);
  }
  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }
//  Future<Database> getDatabase() async {
//    return openDatabase(
//      // Set the path to the database. Note: Using the `join` function from the
//      // `path` package is best practice to ensure the path is correctly
//      // constructed for each platform.
//      join(await getDatabasesPath(), 'zennote_database191.db'),
//      // When the database is first created, create a table to store dogs.
//      onCreate: (db, version) async {
//        await db.execute(DROP_TABLE_NOTE);
//        await db.execute(DROP_TABLE_TAG);
//        await db.execute(DROP_TABLE_NOTE_ITEM);
//        await db.execute(DROP_TABLE_RELATIVE);
//        await db.execute(DROP_TABLE_THUMBNAIL);
//
//        await db.execute(CREATE_TABLE_TAG);
//        await db.execute(CREATE_TABLE_THUMBNAIL_NOTE);
//        await db.execute(CREATE_TABLE_NOTE_ITEM);
//        await db.execute(CREATE_TABLE_NOTE);
//        await db.execute(CREATE_TABLE_RELATIVE);
//      },
//      // Set the version. This executes the onCreate function and provides a
//      // path to perform database upgrades and downgrades.
//      version: 1,
//    );
}
