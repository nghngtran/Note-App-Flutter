import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/utils/log_history.dart';

class NoteItemDAO {
  final dbProvider = DatabaseApp.dbProvider;

  Future<void> insertNoteItem(NoteItem noteItem,String note_id) async {
    final db = await dbProvider.database;
    var result = await db.insert(
      'noteItems',
      noteItem.toMap(note_id),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog("[NoteItem]", "INSERT new note item:"+noteItem.id+" - "+note_id);
    return result;
  }

  Future<void> updateNoteItem(NoteItem noteItem) async {
    final db = await dbProvider.database;

    // Update the given NoteItem.
    await db.update(
      'noteItems',
      noteItem.toMapWithOutNoteID(),
      // Ensure that the NoteItem has a matching id.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
    LogHistory.trackLog("[NoteItem]", "UPDATE note item:"+noteItem.id);
  }

  Future<void> deleteNoteItem(NoteItem noteItem) async {
    final db = await dbProvider.database;

    // Remove the NoteItem from the database.
    await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "noteItem_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [noteItem.id],
    );
    LogHistory.trackLog("[NoteItem]", "DELETE note item:"+noteItem.id);
  }

   Future<void> deleteNoteItemsByNoteID(String note_id) async {
    final db = await dbProvider.database;

    // Remove the NoteItem from the database.
    await db.delete(
      'noteItems',
      // Use a `where` clause to delete a specific NoteItem.
      where: "note_id = ?",
      // Pass the NoteItem's id as a whereArg to prevent SQL injection.
      whereArgs: [note_id],
    );
    LogHistory.trackLog("[NoteItem]", "DELETE note item by note id:"+note_id);
  }

   Future<NoteItem> getNoteItem(String noteItem_id) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db
        .query('notes', where: "noteItem_id = ?", whereArgs: [noteItem_id]);

    return maps.isEmpty
        ? null
        : NoteItem.withFullInfo(
            maps[0]['noteItem_id'],
            maps[0]['type'],
            maps[0]['content'],
            Color(maps[0]['bgColor']),
            DateTime.parse(maps[0]['created_time']),
            DateTime.parse(maps[0]['modified_time'])
          );
  }

  Future<List<NoteItem>> getNoteItemsByNoteID(String note_id) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('noteItems', where: "note_id = ?", whereArgs: [note_id]);

    // Convert the List<Map<String, dynamic> into a List<NoteItem>.
    return List.generate(maps.length, (i) {
      return NoteItem.withFullInfo(
        maps[i]['noteItem_id'],
        maps[i]['type'],
        maps[i]['content'],
        Color(maps[i]['bgColor']),
        DateTime.parse(maps[i]['created_time']),
        DateTime.parse(maps[i]['modified_time'])
      );
    });
  }
}
