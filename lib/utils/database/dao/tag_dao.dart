import 'dart:async';

import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class TagDAO {
  static Future<void> insertTag(Tag tag) async {
    if(DatabaseApp.database == null){
      print("LOG: TagDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.insert(
      'tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> updateTag(Tag tag) async {
    if(DatabaseApp.database == null){
      print("LOG: TagDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.update(
      'tags',
      tag.toMap(),
      where: "tag_id = ?",
      whereArgs: [tag.id],
    );
  }
  static Future<void> deleteTag(Tag tag) async {
    if(DatabaseApp.database == null){
      print("LOG: TagDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.delete(
      'tags',
      where: "tag_id = ?",
      whereArgs: [tag.id],
    );
  }
  static Future<Tag> getTagByID(String tag_id) async {
    if(DatabaseApp.database == null){
      print("LOG: TagDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    final List<Map<String, dynamic>> maps =
    await db.query('tags', where: "tag_id = ?", whereArgs: [tag_id]);

    return maps.isEmpty? null : Tag.withFullInfo(
      maps[0]['tag_id'],
      maps[0]['title'],
      maps[0]['color'],
      DateTime.parse(maps[0]['created_time']),
      DateTime.parse(maps[0]['modified_time']),
    );
  }
  static Future<List<Tag>> getTags() async {
    if(DatabaseApp.database == null){
      print("LOG: TagDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

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