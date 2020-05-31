import 'dart:async';

import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

class ThumbnailNoteDAO {
  final dbProvider = DatabaseApp.dbProvider;
  //Insert new Thumbnail
  Future<int> insertThumbnail(ThumbnailNote thumbnail) async {
    final db = await dbProvider.database;
    var result = await db.insert(
      'thumbnails',
      thumbnail.toMap(),
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }
  //Get all Thumbnails
  Future<List<ThumbnailNote>> getThumbnails() async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps = await db.query('thumbnails');

    List<ThumbnailNote> note = maps.isNotEmpty
        ? maps.map((item) =>
          ThumbnailNote.fromDatabaseJson(item)).toList()
        : [];

    var list = List.generate(maps.length, (i) {
      return ThumbnailNote.withOutTag(
          maps[i]['note_id'],
          maps[i]['title'],
          maps[i]['content'],
          DateTime.parse(maps[i]['modified_time']));
    });
//
//    //List<ThumbnailNote> list = new List<ThumbnailNote>();
//    list.forEach((f) async => {
//      f.setTag(await TagDAO.getTagsByNoteID(f.note_id))
//    });
//    var tags;
//    maps.forEach((f) async => {
//          tags = await TagDAO.getTagsByNoteID(f['note_id']),
//          list.add(ThumbnailNote(f['note_id'], f['tag_id'], tags, f['title'],
//              DateTime.parse(f['modified_time']))),
//        });
    return list;
  }
}
