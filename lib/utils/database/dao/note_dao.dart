import 'dart:async';

import 'package:note_app/utils/database/dao/noteItem_dao.dart';
import 'package:note_app/utils/database/dao/relative_dao.dart';
import 'package:note_app/utils/database/dao/thumbnail_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/db_commands.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:note_app/utils/database/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../log_history.dart';

class NoteDAO {
  static Future<void> insertNote(Notes note) async {
    if (DatabaseApp.database == null) {
      print(
          "LOG: NoteDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog("Note", "insert new note:" + note.id);
    note.contents
        .forEach((noteItem) => NoteItemDAO.insertNoteItem(noteItem, note.id));
    note.tags.forEach((tag) => RelativeDAO.insertRelative(note.id, tag.id));

    print("Save content:"+note.contents[0].content);
    ThumbnailNote thumbnail = new ThumbnailNote(
        note.id, note.title, note.tags, note.contents[0].content, note.modified_time);
    ThumbnailNoteDAO.insertThumbnail(thumbnail);
  }

  static Future<void> updateNote(Notes note) async {
//    if (DatabaseApp.database == null) {
//      print(
//          "LOG: NoteDAO can't start because DatabaseApp not start! please start DatabaseApp");
//      return null;
//    }
//    final Database db = await DatabaseApp.database;
    deleteNoteByID(note.id);
    insertNote(note);

    /*
    await db.update(
      'tags',
      note.toMap(),
      where: "note_id = ?",
      whereArgs: [note.id],
    );*/
  }

  static Future<void> deleteNoteByID(String note_id) async {
    if (DatabaseApp.database == null) {
      print(
          "LOG: NoteDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.delete(
      'notes',
      where: "note_id = ?",
      whereArgs: [note_id],
    );
    LogHistory.trackLog("Note", "insert new note:" + note_id);
    NoteItemDAO.deleteNoteItemsByNoteID(note_id);
    RelativeDAO.deleteRelativeByNoteID(note_id);
  }

  //Find note full info of Note by passing id
  static Future<Notes> getNoteByID(String note_id) async {
    final Database db = await DatabaseApp.database;
    // Get List Note
    final List<Map<String, dynamic>> maps =
    await db.query('notes', where: "note_id = ?", whereArgs: [note_id]);
    // Case Found
    if (maps.isNotEmpty) {
      //build basic note with basic field
      Notes res = Notes.withFullInfo(
          maps[0]['note_id'],
          maps[0]['title'],
          DateTime.parse(maps[0]['created_time']),
          DateTime.parse(maps[0]['modified_time']));

      //build state of Note

      //build tag
      final List<Map<String, dynamic>> join =
      await db.rawQuery(SELECT_TAG_RELATIVES_JOIN_TAGS, [note_id]);
      res.setTag(List.generate(join.length, (i) {
        return Tag.withFullInfo(
            join[i]['tag_id'],
            join[i]['title'],
            join[i]['color'],
            DateTime.parse(join[i]['created_time']),
            DateTime.parse(join[i]['modified_time']));
      }));
      //build content
      final List<Map<String, dynamic>> noteItemList =
      await db.rawQuery(SELECT_NOTE_ITEMS, [note_id]);
      res.setNoteItem(List.generate(noteItemList.length, (i) {
        return NoteItem.withFullInfo(
            noteItemList[i]['noteItem_id'],
            noteItemList[i]['type'],
            noteItemList[i]['content'],
            noteItemList[i]['textColor'],
            noteItemList[i]['bgColor'],
            DateTime.parse(noteItemList[i]['created_time']),
            DateTime.parse(noteItemList[i]['modified_time']));
      }));

      return res;
    }
    // Case not Found any Note
    return null;
  }

  //Find basic note (with out content and tag)
  static Future<List<Notes>> getNotes() async {
    final Database db = await DatabaseApp.database;

    final List<Map<String, dynamic>> maps = await db.query('notes');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(maps.length, (i) {
      return Notes.withFullInfo(
          maps[i]['note_id'],
          maps[i]['title'],
          DateTime.parse(maps[i]['created_time']),
          DateTime.parse(maps[i]['modified_time']));
    });
  }

  //Find note basic by Tag_id
  static Future<List<Notes>> getNoteByTagID(String tag_id) async {
    final Database db = await DatabaseApp.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        SELECT_NOTES_BY_TAGID, [tag_id]);
    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(maps.length, (i) {
      return Notes.withFullInfo(
          maps[i]['note_id'],
          maps[i]['title'],
          DateTime.parse(maps[i]['created_time']),
          DateTime.parse(maps[i]['modified_time']));
    });
  }

  static Future<Notes> getNoteByNoteItem(NoteItem noteItem) async {

  }

  //Find note basic by Keyword in title and content
  static Future<List<Notes>> getNoteByKeyWord(String keyword) async {
    final Database db = await DatabaseApp.database;
    //Using full text search sql table Note
    final List<Map<String, dynamic>> notes = await db.rawQuery(
        FTS_NOTE, [keyword]);

    return List.generate(notes.length, (i) {
      return Notes.withFullInfo(
          notes[i]['note_id'],
          notes[i]['title'],
          DateTime.parse(notes[i]['created_time']),
          DateTime.parse(notes[i]['modified_time']));
    });

    //final List<Map<String, dynamic>> noteitems = await db.rawQuery(FTS_NOTE_ITEM,[keyword]);


  }
}
