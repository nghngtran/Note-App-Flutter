import 'dart:async';

import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';
import '../log_history.dart';

class ThumbnailNoteDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final tagDao = TagDAO();

  //Insert new Thumbnail
  Future<String> createThumbnail(ThumbnailNote thumbnail) async {
    final db = await dbProvider.database;
    var thumbId = await db.insert(
      'thumbnails',
      thumbnail.toDatabaseJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog(
        "[Thumbnail]", "INSERT new thumbnail note:" + thumbnail.noteId.toString());
    return thumbId.toString();
  }

  Future<ThumbnailNote> getThumbnailByID(String noteId) async {
    final db = await dbProvider.database;
    // Get List Note
    List<Map<String, dynamic>> maps = await db
        .query('thumbnails', where: "note_id = ?", whereArgs: [noteId]);
    // Case Found
    if (maps.isNotEmpty) {
      var tags = await tagDao.getTagsByNoteID(noteId);
      var result = ThumbnailNote.fromDatabaseJson(maps[0]);
      result.setTag(tags);
      return result;
    }
    return null;
  }

  //Get all Thumbnails
  Future<List<ThumbnailNote>> getThumbnails(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('thumbnails',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('thumbnails', columns: columns);
    }

    List<ThumbnailNote> thumbs = result.isNotEmpty
        ? result.map((item) => ThumbnailNote.fromDatabaseJson(item)).toList()
        : [];
    if (thumbs.isNotEmpty) {
      for (var thumb in thumbs) {
        var tags = await tagDao.getTagsByNoteID(thumb.noteId);
        //print(tags);
        thumb.setTag(tags);
      }
    }
    return thumbs;
  }

  Future<List<ThumbnailNote>> findThumbnailByKeyWord(String keyword) async {
    final db = await dbProvider.database;
    //Using full text search sql table Note
    final List<Map<String, dynamic>> notes =
        await db.rawQuery(FTS_NOTE, [keyword]);

    List<ThumbnailNote> thumbs = new List<ThumbnailNote>();

    for (var note in notes) {
      var thumb = await getThumbnailByID(note['note_id']);
      thumbs.add(thumb);
    }
    return thumbs;
  }

  Future deleteAllThumbnails() async {
    final db = await dbProvider.database;
    var result = await db.delete('thumbnails');
    LogHistory.trackLog("[Thumbnail]", "DELETE All thumbnail");
    return result;
  }

  Future<int> deleteThumbnail(String noteId) async {
    final db = await dbProvider.database;
    var result = await db
        .delete('thumbnails', where: "note_id = ?", whereArgs: [noteId]);
    LogHistory.trackLog("[Thumbnail]", "DELETE thumbnail of note: " + noteId.toString());
    return result;
  }

  Future<int> updateThumbnail(ThumbnailNote thumbnail) async {
    final db = await dbProvider.database;
    var result = await db.update(
      'thumbnails',
      thumbnail.toDatabaseJson(),
      where: "note_id = ?",
      whereArgs: [thumbnail.noteId],
    );
    LogHistory.trackLog(
        "[Note]", "UPDATE thumbnail of note:" + thumbnail.noteId.toString());
    return result;
  }
  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT,['thumbnails']));
    return count;
  }
}
