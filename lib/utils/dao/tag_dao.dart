import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/utils/log_history.dart';

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
    LogHistory.trackLog("[TAG]", "INSERT tag:"+tag.id);
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
    LogHistory.trackLog("[TAG]", "UPDATE tag:" + tag.id);
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
    LogHistory.trackLog("[TAG]", "DELETE tag:" + tag_id);
    return result;
  }
  //Delete All Note Record
  Future deleteAllTags() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'tags',
    );
    LogHistory.trackLog("[TAG]", "DELETE all tag");
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
  Future<List<Tag>> getTagsByNoteID(String note_id) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> result = await db
        .rawQuery(SELECT_TAG_RELATIVES_JOIN_TAGS, [note_id]);
    List<Tag> tags = result.isNotEmpty
        ? result.map((item) => Tag.fromDatabaseJson(item)).toList()
        : [];
    return tags;
  }
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