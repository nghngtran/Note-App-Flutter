import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class TagDAO {
  final dbProvider = DatabaseApp.dbProvider;

  //Insert new Tag
  Future<int> createTag(Tag tag) async {
    final db = await dbProvider.database;

    var result = await db.insert(
      'tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }
  //Update Tag with another Tag with same tag_id
  Future<int> updateTag(Tag tag) async {
    final db = await dbProvider.database;

    var result = await db.update(
      'tags',
      tag.toMap(),
      where: "tag_id = ?",
      whereArgs: [tag.id],
    );
    return result;
  }
  //Delete exist Tag with Tag
  Future<int> deleteTag(String tag_id) async {
    final db = await dbProvider.database;

    var result = await db.delete(
      'tags',
      where: "tag_id = ?",
      whereArgs: [tag_id],
    );
    return result;
  }
  //Delete All Note Record
  Future deleteAllTags() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'tags',
    );
    return result;
  }

  //Find Tag by tag_id
  Future<Tag> getTagByID(String tag_id) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps =
    await db.query('tags', where: "tag_id = ?", whereArgs: [tag_id]);

    if (maps.isNotEmpty) {
      return Tag.fromDatabaseJson(maps[0]);
    }
    return null;
  }
//  static Future<List<Tag>> getTagsByNoteID(String note_id) async {
//    if(DatabaseApp.dbProvider == null){
//      print("LOG: TagDAO can't start because DatabaseApp not start! please start DatabaseApp");
//      return null;
//    }
//    final Database db = await DatabaseApp.dbProvider;
//    final List<Map<String, dynamic>> join = await db
//        .rawQuery(SELECT_TAG_RELATIVES_JOIN_TAGS, [note_id]);
//    return List.generate(join.length, (i) {
//      return Tag.withFullInfo(
//          join[i]['tag_id'],
//          join[i]['title'],
//          Color(join[i]['color']),
//          DateTime.parse(join[i]['created_time']),
//          DateTime.parse(join[i]['modified_time']));
//    });
//  }
  //Get List Tag in Database
  Future<List<Tag>> getTags({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('tags',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('tags', columns: columns);
    }

    List<Tag> note = result.isNotEmpty
        ? result.map((item) => Tag.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }
}