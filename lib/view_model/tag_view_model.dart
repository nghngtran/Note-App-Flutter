import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';

class NoteTagsViewModel extends BaseModel {
  List<Tag> listTagOfNote = [];
  List<Tag> get listTag {
    return listTagOfNote;
  }

  int get listSize {
    return listTagOfNote != null ? listTagOfNote.length : 0;
  }

  void addToList(Tag tag) {
    listTagOfNote.add(tag);
    notifyListeners();
  }

  List<Tag> getTagCreated() {
    return listTagOfNote;
  }

  void clear() {
    listTagOfNote = [];
    notifyListeners();
  }
}
