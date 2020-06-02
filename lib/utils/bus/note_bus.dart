import 'dart:async';

import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/repository/note_repo.dart';

class NoteBUS {
  final _noteRepository = NoteRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _noteController = StreamController<List<Notes>>.broadcast();

  get notes => _noteController.stream;
//  NoteBUS(){
//    getNotes();
//  }
  NoteBloc() {
    getNotes();
  }

  getNotes({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    var result = await _noteRepository.getAllNotes(query: query);
    _noteController.sink.add(result);
    return result;
  }
  getNoteById(int note_id) async {
    return await _noteRepository.getNote(note_id);
  }
  addNote(Notes note) async {
    var code = await _noteRepository.insertNotes(note);
    getNotes();
    return code;
  }

  updateNote(Notes note) async {
    var code = await _noteRepository.updateNotes(note);
    getNotes();
    return code;
  }

  deleteNoteById(int id) async {
    var code = _noteRepository.deleteNotesById(id);
    getNotes();
    return code;
  }

  dispose() {
    _noteController.close();
  }
}