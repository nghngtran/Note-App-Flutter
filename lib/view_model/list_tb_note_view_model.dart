import 'package:note_app/utils/bus/note_bus.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';

class NoteCreatedModel extends BaseModel {
  ThumbnailBUS noteBus = ThumbnailBUS();
  List<ThumbnailNote> listNoteCreated = [];

  void loadData() async {
    listNoteCreated = await noteBus.getThumbnails();
    notifyListeners();
  }

  void loadDataByKeyword(String key) async {
    listNoteCreated = await noteBus.getThumbnailsByKeyWord(key);
    notifyListeners();
  }

  int get listSize {
    return listNoteCreated != null ? listNoteCreated.length : 0;
  }

  void addToList(ThumbnailNote note) {
    listNoteCreated.add(note);
    notifyListeners();
  }

  List<ThumbnailNote> getNoteCreated() {
    return listNoteCreated;
  }

  void clear() {
    listNoteCreated = [];
    notifyListeners();
  }
}
