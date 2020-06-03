import 'dart:async';

import 'package:note_app/utils/database/database.dart';
import 'package:note_app/utils/db_commands.dart';
import 'package:note_app/utils/log_history.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:sqflite/sqflite.dart';

class RelativeDAO {
  final dbProvider = DatabaseApp.dbProvider;

  Future<int> insertRelative(String noteId, String tagId) async {
    final db = await dbProvider.database;

    var res = await db.insert(
      'relatives',
      toMap(noteId, tagId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    LogHistory.trackLog(
        "[Relative]",
        "INSERT new relative note:" +
            noteId.toString() +
            " with tag:" +
            tagId.toString());
    return res;
  }
  Future<void> insertRelativesFromTagList(String noteId, List<Tag> tags) async{
    for(var tag in tags){
      await insertRelative(noteId, tag.id);
    }
  }
  Future<int> deleteRelative(int noteId, int tagId) async {
    final db = await dbProvider.database;

    var res = await db.delete(
      'relatives',
      where: "note_id = ? and tag_id = ?",
      whereArgs: [noteId, tagId],
    );
    LogHistory.trackLog("[Relative]",
        "DELETE relative note:" + noteId.toString() + " with tag:" + tagId.toString());
    return res;
  }

  Future<int> deleteRelativesByTagID(String tagId) async {
    final db = await dbProvider.database;

    var res = await db.delete(
      'relatives',
      where: "tag_id = ?",
      whereArgs: [tagId],
    );
    LogHistory.trackLog("[Relative]", "DELETE all relative of tag:" + tagId.toString());
    return res;
  }

  Future<int> deleteRelativesByNoteID(String noteId) async {
    final db = await dbProvider.database;

    var res = await db.delete(
      'relatives',
      where: "note_id = ?",
      whereArgs: [noteId],
    );
    LogHistory.trackLog("[Relative]", "DELETE all relative of note:" + noteId.toString());
    return res;
  }

  Future<int> deleteAllRelatives() async {
    final db = await dbProvider.database;

    var res = await db.delete('relatives');
    LogHistory.trackLog("[Relative]", "DELETE all relative");
    return res;
  }

  Future<List<Relative>> getRelativesByNoteID(String noteId) async {
    final db = await dbProvider.database;

    // Query the table for all The NoteItem of identify Note.
    final List<Map<String, dynamic>> maps =
        await db.query('relatives', where: "note_id = ?", whereArgs: [noteId]);
    return List.generate(maps.length, (i) {
      return Relative(maps[i]['note_id'], maps[i]['tag_id']);
    });
  }

  Map<String, dynamic> toMap(String noteId, String tagId) {
    return {'note_id': noteId, 'tag_id': tagId};
  }
  Future<int> getCounts() async {
    final db = await dbProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(COUNT,['relatives']));
    return count;
  }
}

class Relative {
  String noteId;
  String tagId;

  Relative(this.noteId, this.tagId);
  String toString(){
    return "<Relative Note_id=\""+noteId.toString()+
        "\" Tag_id=\"" + tagId.toString() +
        "\"/>";
  }
}
