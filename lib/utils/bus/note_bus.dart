import 'dart:async';

import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/repository/note_repo.dart';

class NoteBUS {
  final _noteRepository = NoteRepository();

  NoteBloc() {
    getNotes();
  }

  getNotes({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    var result = await _noteRepository.getAllNotes(query: query);
    //_noteController.sink.add(result);
    return result;
  }

  getNoteById(String noteId) async {
    return await _noteRepository.getNote(noteId);
  }

  addNote(Notes note) async {
    if(note.contents.isEmpty) return false;
    var rowId = await _noteRepository.insertNotes(note);
    //getNotes();
    return rowId;
  }
  updateNote(Notes note) async {
    if(note.contents.isEmpty) return false;
    return await _noteRepository.updateNotes(note) > 0;
    //getNotes();
    //return count;
  }

  deleteNoteById(String id) async {
    return await _noteRepository.deleteNotesById(id) > 0;
    //getNotes();
    //return code;
  }

//  dispose() {
//    _noteController.close();
//  }
}
