import 'dart:async';

import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/log_history.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:sqflite/sqflite.dart';

class NoteItemDAO {
  final dbProvider = DatabaseApp.dbProvider;

  //Insert NoteItem with note ID
  Future<String> insertNoteItem(NoteItem noteItem, String noteId) async {
    final db = await dbProvider.database;
    var noteItemId = await db.insert(
      'noteItems',
      noteItem.toDatabaseJson(noteId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog(
        "[NoteItem]", "INSERT new note item:" + noteItemId.toString() + " of note: " + noteId.toString());
    return noteItemId.toString();
  }

  //Update NoteItem with noteItem
  Future<int> updateNoteItem(NoteItem noteItem) async {
    final db = await dbProvider.database;

    // Update the given NoteItem.
    var count = await db.update(
      'noteItems',
      noteItem.toDatabaseJsonWithOutNoteID(),
      // Ensure that the NoteItem has a matching id.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
    LogHistory.trackLog("[NoteItem]", "UPDATE note item:" + noteItem.id.toString());
    return count;
  }

  //Delete NoteItem
  Future<int> deleteNoteItem(String noteItemId) async {
    final db = await dbProvider.database;

    // Remove the NoteItem from the database.
    var res = await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItemId],
    );
    LogHistory.trackLog("[NoteItem]", "DELETE note item:" + noteItemId.toString());
    return res;
  }

  //Delete NoteItem by NoteID
  Future<void> deleteNoteItemsByNoteID(String noteId) async {
    final db = await dbProvider.database;

    // Remove the NoteItem from the database.
    var res = await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "note_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteId],
    );
    LogHistory.trackLog("[NoteItem]", "DELETE note item by note id:" + noteId.toString());
    return res;
  }

  //Delete All NoteItem
  Future<void> deleteAllNoteItem() async {
    final db = await dbProvider.database;

    // Remove the NoteItem from the database.
    var res = await db.delete('noteItems');
    LogHistory.trackLog("[NoteItem]", "DELETE All note item");
    return res;
  }

  //Get Single NoteItem
  Future<NoteItem> getNoteItem(String noteId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps =
        await db.query('notes', where: "noteItem_id = ?", whereArgs: [noteId]);

    return maps.isEmpty ? null : NoteItem.fromDatabaseJson(maps[0]);
  }

  Future<List<NoteItem>> getNoteItemsByNoteID(String noteId) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('noteItems', where: "note_id = ?", whereArgs: [noteId]);

    // Convert the List<Map<String, dynamic> into a List<NoteItem>.
    List<NoteItem> note = maps.isNotEmpty
        ? maps.map((item) => NoteItem.fromDatabaseJson(item)).toList()
        : [];
    return note;
  }
  Future<int> updateOrder(int order) async {
    final db = await dbProvider.database;

    var orderId = await db.insert(
      'tableCount',
      {'id':'noteItems',
        'count':order},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return orderId;
  }
  Future<int> getOrder() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> maps =
    await db.query('tableCount', where: "id = ?", whereArgs: ["noteItems"]);
    if(maps.isNotEmpty)
      return maps[0]['count'];
    else return 0;
  }
  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT,['noteItems']));
    return count;
  }
}
