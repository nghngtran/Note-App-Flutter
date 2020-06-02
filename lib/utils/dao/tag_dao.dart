import 'dart:async';

import 'package:note_app/utils/dao/relative_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/log_history.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class TagDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final relativeDao = RelativeDAO();

  //Insert new Tag
  Future<int> createTag(Tag tag) async {
    final db = await dbProvider.database;

    var tagId = await db.insert(
      'tags',
      tag.toDatabaseJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    LogHistory.trackLog("[TAG]", "INSERT tag:" + tagId.toString());
    return tagId;
  }

  //Update Tag with another Tag with same tag_id
  Future<int> updateTag(Tag tag) async {
    final db = await dbProvider.database;

    var count = await db.update(
      'tags',
      tag.toDatabaseJson(),
      where: "tag_id = ?",
      whereArgs: [tag.id],
    );
    LogHistory.trackLog("[TAG]", "UPDATE tag:" + tag.id.toString());
    return count;
  }

  //Delete exist Tag with Tag
  Future<int> deleteTag(int tagId) async {
    final db = await dbProvider.database;

    var result = await db.delete(
      'tags',
      where: "tag_id = ?",
      whereArgs: [tagId],
    );
    await relativeDao.deleteRelativesByTagID(tagId);

    LogHistory.trackLog("[TAG]", "DELETE tag:" + tagId.toString());
    return result;
  }

  //Delete All Note Record
  Future deleteAllTags() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'tags',
    );
    await relativeDao.deleteAllRelatives();
    LogHistory.trackLog("[TAG]", "DELETE all tag");
    return result;
  }

  //Find Tag by tag_id
  Future<Tag> getTagByID(int tagId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps =
        await db.query('tags', where: "tag_id = ?", whereArgs: [tagId]);

    if (maps.isNotEmpty) {
      return Tag.fromDatabaseJson(maps[0]);
    }
    return null;
  }
  //Find Tag by title
  Future<Tag> getTagByTitle(String title) async{
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps =
    await db.query('tags', where: "title = ?", whereArgs: [title]);

    if (maps.isNotEmpty) {
      return Tag.fromDatabaseJson(maps[0]);
    }
    return null;
  }
  //Get List Tag of Note
  Future<List<Tag>> getTagsByNoteID(int noteId) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> result =
        await db.rawQuery(SELECT_TAG_RELATIVES_JOIN_TAGS, [noteId]);

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
  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT,['tags']));
    return count;
  }
}
