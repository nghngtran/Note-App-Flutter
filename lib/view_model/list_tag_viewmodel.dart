import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/database/model/tag.dart';

enum ViewState { Idle, Busy }

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  void applyState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}

class TagCreatedModel extends BaseModel {
  List<Tag> listTagCreated = [];
  List<Tag> get listTag {
    return listTagCreated;
  }

  int get listSize {
    return listTagCreated != null ? listTagCreated.length : 0;
  }

  void addToList(Tag tag) {
    listTagCreated.add(tag);
    notifyListeners();
  }

  List<Tag> getTagCreated() {
    return listTagCreated;
  }

  void clear() {
    listTagCreated = [];
    notifyListeners();
  }

//  Future getTags() async {
//    applyState(ViewState.Busy);
//    listTagCreated = await getTags();
//    applyState(ViewState.Idle);
//  }
}
