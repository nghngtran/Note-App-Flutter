import 'dart:async';

import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';
import '../log_history.dart';

class ThumbnailNoteDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final tagDao = TagDAO();

  //Insert new Thumbnail
  Future<int> createThumbnail(ThumbnailNote thumbnail) async {
    final db = await dbProvider.database;
    var result = await db.insert(
      'thumbnails',
      thumbnail.toDatabaseJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog(
        "[Thumbnail]", "INSERT new thumbnail note:" + thumbnail.note_id);
    return result;
  }

  Future<ThumbnailNote> getThumbnailByID(String note_id) async {
    final db = await dbProvider.database;
    // Get List Note
    List<Map<String, dynamic>> maps = await db
        .query('thumbnails', where: "note_id = ?", whereArgs: [note_id]);
    // Case Found
    if (maps.isNotEmpty) {
      var tags = await tagDao.getTagsByNoteID(note_id);
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
    var tags;
    List<ThumbnailNote> thumbs = result.isNotEmpty
        ? result.map((item) =>
                  ThumbnailNote.fromDatabaseJson(item)).toList()
        : [];
    for( var thumb in thumbs){
      var tags = await tagDao.getTagsByNoteID(thumb.note_id);
      thumb.setTag(tags);
    }
    return thumbs;
  }

  Future deleteAllThumbnails() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'thumbnails',
    );
    LogHistory.trackLog("[Thumbnail]", "DELETE All thumbnail");
    return result;
  }

  Future<int> deleteThumbnail(String note_id) async {
    final db = await dbProvider.database;
    var result = await db
        .delete('thumbnails', where: "note_id = ?", whereArgs: [note_id]);
    LogHistory.trackLog("[Thumbnail]", "DELETE thumbnail of note: " + note_id);
    return result;
  }

  Future<int> updateThumbnail(ThumbnailNote thumbnail) async {
    final db = await dbProvider.database;
    //deleteNoteByID(note.id);
    //insertNote(note);
    var result = await db.update(
      'thumbnails',
      thumbnail.toDatabaseJson(),
      where: "note_id = ?",
      whereArgs: [thumbnail.note_id],
    );
    LogHistory.trackLog(
        "[Note]", "UPDATE thumbnail of note:" + thumbnail.note_id);
    return result;
  }
}
