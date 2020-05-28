import 'dart:async';

import 'package:note_app/utils/database/dao/tag_dao.dart';
import 'package:note_app/utils/database/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../database.dart';

class ThumbnailNoteDAO {
  //Insert new Thumbnail
  static Future<void> insertThumbnail(ThumbnailNote thumbnail) async {
    if (DatabaseApp.database == null) {
      print(
          "LOG: Thumbnail can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.insert(
      'thumbnails',
      thumbnail.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  //Get all Thumbnails
  static Future<List<ThumbnailNote>> getThumbnails() async {
    if (DatabaseApp.database == null) {
      print(
          "LOG: Thumbnail can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    final List<Map<String, dynamic>> maps = await db.query('thumbnails');
//    return List.generate(maps.length, (i) {
//      return ThumbnailNote.withOutTag(
//          maps[i]['note_id'],
//          maps[i]['title'],
//          maps[i]['content'],
//          DateTime.parse(maps[i]['modified_time']));
//    });

    List<ThumbnailNote> list = new List<ThumbnailNote>();

    var tags;
    maps.forEach((f) async => {
          tags = await TagDAO.getTagsByNoteID(f['note_id']),
          list.add(ThumbnailNote(f['note_id'], f['tag_id'], tags, f['title'],
              DateTime.parse(f['modified_time']))),
        });
    return list;
  }
}
