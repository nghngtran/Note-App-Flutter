import 'dart:async';

import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/repository/note_repo.dart';

class NoteBUS {
  final _noteRepository = NoteRepository();

  getNotes({String query}) async {
    var result = await _noteRepository.getAllNotes(query: query);
    return result;
  }

  getNoteById(String noteId) async {
    final stopwatch = Stopwatch()..start();
    var res = await _noteRepository.getNote(noteId);
    print('[Time] Query Note by ID ${noteId} executed in ${stopwatch.elapsed}');
    return res;
  }

  addNote(Notes note) async {
    final stopwatch = Stopwatch()..start();
    //if(note.contents.isEmpty) return false;
    var rowId = await _noteRepository.insertNotes(note);
    print('[Time] Add new Note ${note.id} executed in ${stopwatch.elapsed}');
    return rowId;
  }
  updateNote(Notes note) async {
    final stopwatch = Stopwatch()..start();
    if(note.contents.isEmpty) return false;
    var res = await _noteRepository.updateNotes(note);
    print('[Time] Update Note ${note.id} executed in ${stopwatch.elapsed}');
    return res>0;
  }

  deleteNoteById(String noteId) async {
    final stopwatch = Stopwatch()..start();
    var res = await _noteRepository.deleteNotesById(noteId);
    print('[Time] Update Note ${noteId} executed in ${stopwatch.elapsed}');
    return res>0;
  }
}
