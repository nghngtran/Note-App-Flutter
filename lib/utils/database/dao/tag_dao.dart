import 'dart:async';

import 'package:note_app/utils/database/model/tag.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TagDAO {
  final Future<Database> database;

  TagDAO(this.database);
  Future<void> insertTag(Tag tag) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> updateTag(Tag tag) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'tags',
      tag.toMap(),
      // Ensure that the Dog has a matching id.
      where: "tag_id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [tag.id],
    );
  }
  Future<void> deleteTag(Tag tag) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'tags',
      // Use a `where` clause to delete a specific dog.
      where: "tag_id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [tag.id],
    );
  }
  Future<List<Tag>> getTags() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('tags');

    // Convert the List<Map<String, dynamic> into a List<Tag>.
    return List.generate(maps.length, (i) {
      return Tag.withFullInfo(
        maps[i]['tag_id'],
        maps[i]['title'],
        maps[i]['color'],
        DateTime.parse(maps[i]['created_time']),
        DateTime.parse(maps[i]['modified_time']),
      );
    });
  }
}