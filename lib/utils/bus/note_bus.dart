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

  NoteBloc() {
    getNotes();
  }

  getNotes({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _noteController.sink.add(await _noteRepository.getAllNotes(query: query));
  }

  addNote(Notes note) async {
    await _noteRepository.insertNotes(note);
    getNotes();
  }

  updateNote(Notes note) async {
    await _noteRepository.updateNotes(note);
    getNotes();
  }

  deleteNoteById(String id) async {
    _noteRepository.deleteNotesById(id);
    getNotes();
  }

  dispose() {
    _noteController.close();
  }
}