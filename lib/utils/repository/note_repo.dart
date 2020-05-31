import 'package:note_app/utils/dao/note_dao.dart';
import 'package:note_app/utils/model/note.dart';

class NoteRepository {
  final NoteDao = NoteDAO();

  Future getAllNotes({String query}) => NoteDao.getNotes(query: query);

  Future getNote(String id) => NoteDao.getNoteByID(id);

  Future insertNotes(Notes note) => NoteDao.createNote(note);
  Future updateNotes(Notes note) => NoteDao.updateNote(note);

  Future deleteNotesById(String id) => NoteDao.deleteNote(id);

  //We are not going to use this in the demo
  Future deleteAllNotes() => NoteDao.deleteAllNotes();
}