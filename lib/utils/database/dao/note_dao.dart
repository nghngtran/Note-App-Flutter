import 'dart:async';

import 'package:note_app/utils/database/dao/noteItem_dao.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class NoteDAO {
  final Future<Database> database;

  NoteDAO(this.database);

  Future<void> insertNote(Note note) async {
    // Get a reference to the database.
    final Database db = await database;
    NoteItemDAO noteItemDAO = new NoteItemDAO(database);
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    note.contents.forEach((noteItem)=> noteItemDAO.insertNoteItem(noteItem));

    note.tags.forEach((tag) async => await db.insert(
          'notes',
          note.toMap(tag),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));
  }

  Future<void> updateNote(Note note) async {
    // Get a reference to the database.
    //final db = await database;
    deleteNote(note);
    insertNote(note);

    /*// Update the given Dog.
    await db.update(
      'tags',
      note.toMap(),
      // Ensure that the Dog has a matching id.
      where: "note_id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );*/
  }

  Future<void> deleteNote(Note note) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'notes',
      // Use a `where` clause to delete a specific dog.
      where: "note_id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [note.id],
    );
  }

  Future<List<Tag>> getNotes() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('notes');

    // Convert the List<Map<String, dynamic> into a List<Tag>.
    return List.generate(maps.length, (i) {
      return Tag.withFullInfo(
        maps[i]['tag_id'],
        maps[i]['title'],
        maps[i]['color'],
        maps[i]['created_time'],
        maps[i]['modified_time'],
      );
    });
  }
}
