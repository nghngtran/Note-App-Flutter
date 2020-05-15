import 'dart:async';

import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:sqflite/sqflite.dart';

class NoteItemDAO {
  static Future<void> insertNoteItem(NoteItem noteItem,String note_id) async {
    // Get a reference to the database.
    if(DatabaseApp.database == null){
      print("LOG: NoteItemDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    await db.insert(
      'noteItems',
      noteItem.toMap(note_id),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateNoteItem(NoteItem noteItem) async {
    //Get a reference to the database.
    if(DatabaseApp.database == null){
      print("LOG: NoteItemDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    // Update the given NoteItem.
    await db.update(
      'noteItems',
      noteItem.toMapWithOutNoteID(),
      // Ensure that the NoteItem has a matching id.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
  }

  static Future<void> deleteNoteItem(NoteItem noteItem) async {
    // Get a reference to the database.
    if(DatabaseApp.database == null){
      print("LOG: NoteItemDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    // Remove the NoteItem from the database.
    await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
  }

  static Future<void> deleteNoteItemsByNoteID(String note_id) async {
    if(DatabaseApp.database == null){
      print("LOG: NoteItemDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    // Remove the NoteItem from the database.
    await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "note_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [note_id],
    );
  }

  static Future<NoteItem> getNoteItem(String noteItem_id) async {
    if(DatabaseApp.database == null){
      print("LOG: NoteItemDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;
    final List<Map<String, dynamic>> maps = await db
        .query('notes', where: "noteItem_id = ?", whereArgs: [noteItem_id]);
    return maps.isEmpty
        ? null
        : NoteItem.withFullInfo(
            maps[0]['noteItem_id'],
            maps[0]['type'],
            maps[0]['content'],
            maps[0]['textColor'],
            maps[0]['bgColor'],
            DateTime.parse(maps[0]['created_time']),
            DateTime.parse(maps[0]['modified_time'])
          );
  }

  static Future<List<NoteItem>> getNoteItemsByNoteID(String note_id) async {
    // Get a reference to the database.
    if(DatabaseApp.database == null){
      print("LOG: NoteItemDAO can't start because DatabaseApp not start! please start DatabaseApp");
      return null;
    }
    final Database db = await DatabaseApp.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('noteItems', where: "note_id = ?", whereArgs: [note_id]);

    // Convert the List<Map<String, dynamic> into a List<NoteItem>.
    return List.generate(maps.length, (i) {
      return NoteItem.withFullInfo(
        maps[i]['noteItem_id'],
        maps[i]['type'],
        maps[i]['content'],
        maps[i]['textColor'],
        maps[i]['bgColor'],
        DateTime.parse(maps[i]['created_time']),
        DateTime.parse(maps[i]['modified_time'])
      );
    });
  }
}
