import 'dart:async';
import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/log_history.dart';
import 'package:sqflite/sqflite.dart';

class RelativeDAO {
  final dbProvider = DatabaseApp.dbProvider;

  Future<void> insertRelative(String note_id, String tag_id) async {
    final db = await dbProvider.database;

    await db.insert(
      'relatives',
      toMap(note_id, tag_id),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog("[Relative]", "INSERT new relative note:"+note_id.toString()+" with tag:"+tag_id.toString());
  }
  Future<void> deleteRelative(String note_id, String tag_id) async {
    final db = await dbProvider.database;

    await db.delete(
      'relatives',
      where: "note_id = ? and tag_id = ?",
      whereArgs: [note_id,tag_id],
    );
    LogHistory.trackLog("[Relative]", "DELETE relative note:"+note_id+" with tag:"+tag_id);
  }
  Future<void> deleteRelativeByTagID(String tag_id) async{
    final db = await dbProvider.database;

    await db.delete(
      'relatives',
      where: "tag_id = ?",
      whereArgs: [tag_id],
    );
    LogHistory.trackLog("[Relative]", "DELETE all relative of tag:"+tag_id);
  }
  Future<void> deleteRelativeByNoteID(String note_id) async{
    final db = await dbProvider.database;

    await db.delete(
      'relatives',
      where: "note_id = ?",
      whereArgs: [note_id],
    );
    LogHistory.trackLog("[Relative]", "DELETE all relative of note:"+note_id);
  }
  Future<List<Relative>> getRelativesByNoteID(String note_id) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('relatives', where: "note_id = ?", whereArgs: [note_id]);
    return List.generate(maps.length, (i) {
      return Relative(
        maps[i]['note_id'],
        maps[i]['tag_id']
      );
    });
  }

  static Map<String, dynamic> toMap(String note_id, String tag_id) {
    return {
      'note_id': note_id,
      'tag_id': tag_id
    };
  }
}
class Relative{
  String note_id;
  String tag_id;
  Relative(this.note_id,this.tag_id);
}