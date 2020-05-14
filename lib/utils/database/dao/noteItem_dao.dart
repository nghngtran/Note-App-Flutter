import 'dart:async';

import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:sqflite/sqflite.dart';

class NoteItemDAO {
  final Future<Database> database;

  NoteItemDAO(this.database);

  Future<void> insertNoteItem(NoteItem noteItem) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same NoteIem is inserted
    // multiple times, it replaces the previous data.

    await db.insert(
      'noteItems',
      noteItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> updateNoteItem(NoteItem noteItem) async {
    //Get a reference to the database.
    final db = await database;

    // Update the given NoteItem.
    await db.update(
      'noteItems',
      noteItem.toMap(),
      // Ensure that the NoteItem has a matching id.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
  }
  Future<void> deleteNoteItem(NoteItem noteItem) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the NoteItem from the database.
    await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
  }
  Future<void> deleteNoteItems(Note note) async{
    final db = await database;

    // Remove the NoteItem from the database.
    await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "note_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
  }

  Future<NoteItem> getNoteItem(NoteItem noteItem) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('notes', where: "noteItem_id = ?", whereArgs: [noteItem.id]);
    return maps.isEmpty
        ? null
        : NoteItem.withFullInfo(
            maps[0]['noteItem_id'],
            maps[0]['note_id'],
            maps[0]['type'],
            maps[0]['content'],
            maps[0]['textColor'],
            maps[0]['bgColor'],
            maps[0]['created_time'],
            maps[0]['modified_time'],
          );
  }
  Future<List<NoteItem>> getNoteItems(Note note) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('notes', where: "note_id = ?", whereArgs: [note.id]);

    // Convert the List<Map<String, dynamic> into a List<Tag>.
    return List.generate(maps.length, (i) {
      return NoteItem.withFullInfo(
        maps[i]['noteItem_id'],
        maps[i]['note_id'],
        maps[i]['type'],
        maps[i]['content'],
        maps[i]['textColor'],
        maps[i]['bgColor'],
        maps[i]['created_time'],
        maps[i]['modified_time'],
      );
    });
  }
}
