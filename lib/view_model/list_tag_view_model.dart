import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/bus/tag_bus.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:scoped_model/scoped_model.dart';

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
  TagBUS tagBus = TagBUS();
  List<Tag> listTagCreated = [];
  Future<void> loadData() async {
    listTagCreated = await tagBus.getTags();
    //notifyListeners();
  }

  Future<void> loadTag() async {
    listTagCreated = await tagBus.getTags();
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
}
