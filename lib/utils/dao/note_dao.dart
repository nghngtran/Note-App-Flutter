import 'dart:async';

import 'package:note_app/utils/dao/noteItem_dao.dart';
import 'package:note_app/utils/dao/relative_dao.dart';
import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/dao/thumbnail_dao.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:sqflite/sqflite.dart';

import '../log_history.dart';

class NoteDAO {
  final dbProvider = DatabaseApp.dbProvider;
  final tagDao = TagDAO();
  final thumbnailNoteDao = ThumbnailNoteDAO();
  final noteItemDao = NoteItemDAO();
  final relativeDao = RelativeDAO();

  //Insert new Note
  Future<String> createNote(Notes note) async {
    final db = await dbProvider.database;
    var noteId = await db.insert(
      'notes',
      note.toDatabaseJson(),
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //Insert NoteItem
    for(var noteItem in note.contents){
      await noteItemDao.insertNoteItem(noteItem, note.id);
    }
    //Insert Tag Relative
    for(var tag in note.tags){
      //tag.id = await tagDao.createTag(tag);
      await relativeDao.insertRelative(note.id, tag.id);
    }

    ThumbnailNote thumbnail = new ThumbnailNote(note.id, note.title, note.tags,
        note.contents[0].content, note.modified_time);
    thumbnailNoteDao.createThumbnail(thumbnail);

    LogHistory.trackLog("[Note]", "INSERT new note:" + note.id.toString());
    return noteId.toString();
  }

//Update a Note
  Future<int> updateNote(Notes note) async {
    final db = await dbProvider.database;
    var count = await db.update(
      'notes',
      note.toDatabaseJson(),
      where: "note_id = ?",
      whereArgs: [note.id],
    );

    await relativeDao.deleteRelativesByNoteID(note.id);
    await relativeDao.insertRelativesFromTagList(note.id, note.tags);

    for (var noteItem in note.contents) {
      await noteItemDao.updateNoteItem(noteItem);
    }

    LogHistory.trackLog("[Note]", "UPDATE note:" + note.id.toString());
    return count;
  }

  //Delete Note Record
  Future<int> deleteNote(String noteId) async {
    final db = await dbProvider.database;
    var count =
        await db.delete('notes', where: "note_id = ?", whereArgs: [noteId]);

    await relativeDao.deleteRelativesByNoteID(noteId);
    await noteItemDao.deleteNoteItemsByNoteID(noteId);

    LogHistory.trackLog("[Note]", "DELETE note:" + noteId.toString());
    return count;
  }

  //Delete All Note Record
  Future<int> deleteAllNotes() async {
    final db = await dbProvider.database;
    var count = await db.delete(
      'notes',
    );
    await noteItemDao.deleteAllNoteItem();
    await tagDao.deleteAllTags();

    LogHistory.trackLog("[Note]", "DELETE ALL note");
    return count;
  }

  //Get All Note
  //Searches if query string was passed
  Future<List<Notes>> getNotes({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query('notes',
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query('notes', columns: columns);
    }

    List<Notes> note = result.isNotEmpty
      ? result.map((item) => Notes.fromDatabaseJson(item)).toList()
      : [];
  return note;
}

  Future<List<Notes>> getNotesFullData() async {
    //TODO
    return null;
  }

  Future<Notes> getNoteByID(String noteId) async {
    final db = await dbProvider.database;
    // Get List Note
    List<Map<String, dynamic>> maps =
        await db.query('notes', where: "note_id = ?", whereArgs: [noteId]);
    // Case Found
    if (maps.isNotEmpty) {
      var tags = await tagDao.getTagsByNoteID(noteId);
      var noteItems = await noteItemDao.getNoteItemsByNoteID(noteId);
      var note = Notes.fromDatabaseJson(maps[0]);
      note.setTag(tags);
      note.setListNoteItems(noteItems);

      return note;
    }
    return null;
  }
  Future<int> updateOrder(int order) async {
    final db = await dbProvider.database;

    var orderId = await db.insert(
      'tableCount',
      {'id':'notes',
        'count':order},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return orderId;
  }
  Future<int> getOrder() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> maps =
    await db.query('tableCount', where: "id = ?", whereArgs: ["notes"]);
    if(maps.isNotEmpty)
      return maps[0]['count'];
    else return 0;
  }
  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT, ['notes']));
    return count;
  }
}
