import 'dart:async';

import 'package:note_app/utils/database/dao/noteItem_dao.dart';
import 'package:note_app/utils/database/dao/relative_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/db_commands.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';
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
  //get full info of Note by passing id
  static Future<Notes> getNoteByID(String note_id) async {
    final Database db = await DatabaseApp.database;

    final List<Map<String, dynamic>> maps =
        await db.query('notes', where: "note_id = ?", whereArgs: [note_id]);
    if (maps.isNotEmpty) {
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
      final List<Map<String,dynamic>> noteItemList = 
          await db.rawQuery(SELECT_NOTE_ITEMS,[note_id]);
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
    return null;
  }
  //get basic info with out content and tag
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
}
