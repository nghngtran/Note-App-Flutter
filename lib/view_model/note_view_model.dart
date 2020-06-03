import 'dart:collection';

import 'package:note_app/utils/database/model/TimeUtils.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/utils/database/model/tag.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';

class Audio extends NoteItem {
  String path;
  Audio() : super("Audio");
  void setPath(String _path) {
    this.path = _path;
  }
}

class NoteViewModel extends BaseModel {
  String title = "New untitled note";
  List<Tag> tags = [];
  List<NoteItem> contents = [];
  int get size {
    return contents != null ? contents.length : 0;
  }

  void setContentChildItem(String content) {
    this.contents.last.setContent(content);
    notifyListeners();
  }

  List<NoteItem> getListItems() {
    return contents;
  }

  void clear() {
    contents = [];
    notifyListeners();
  }

  NoteViewModel() : super() {
    this.title = "New untitled note";
    this.tags = new List<Tag>();
    this.contents = new List<NoteItem>();
  }
//  NoteViewModel.withFullInfo(
//      this.id, this.title, DateTime created_time, DateTime modified_time) {
//    this.tags = new List<Tag>();
//    this.contents = new List<NoteItem>();
////    this.created_time = created_time;
////    this.modified_time = modified_time;
//  }
//  NoteViewModel.withTitle(String title) {
//    this.id = "note" + ((++order).toString());
//    this.tags = new List<Tag>();
//    this.contents = new List<NoteItem>();
//    this.history = new List<String>();
//    this.history.add(TimeUtils.formatter.format(DateTime.now()));
//    this.title = title;
//  }
//
//  NoteViewModel.withTag(Tag tag) : super() {
//    this.id = "note" + ((++order).toString());
//    this.title = "New Note";
//    this.tags = new List<Tag>();
//    this.contents = new List<NoteItem>();
//    this.history = new List<String>();
//    this.history.add(TimeUtils.formatter.format(DateTime.now()));
//    this.tags.add(tag);
//  }

//  //Set Attribute
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void removeTitle() {
    this.title = "New Note";
  }

  void setTag(List<Tag> tags) {
    this.tags.addAll(tags);
    //this.tags = this.tags.toSet().toList();
  }

  void addTag(Tag tag) {
    this.tags.add(tag);
    notifyListeners();
  }

  void removeTag(List<Tag> tags) {
    tags.forEach((element) => this.tags.remove(element));
    notifyListeners();
  }

  void setNoteItem(List<NoteItem> noteItems) {
    this.contents.addAll(noteItems);
    notifyListeners();
  }

  void addNoteItem(NoteItem noteItem) {
    this.contents.add(noteItem);
    notifyListeners();
  }

  void removeNoteItem(NoteItem noteItem) {
    this.contents.remove(noteItem);
    notifyListeners();
  }

  NoteItem getNoteItemAt(index) {
    return this.contents[index];
  }

//  String toString() {
//    return id + "  |  " + title + "  |  ";
//        created_time.toString() +
//        "  |  " +
//        modified_time.toString();
//  }

//  Map<String, dynamic> toMap() {
//    var formatter = TimeUtils.formatter;
//    return {
//      'note_id': id,
//      'title': title,
////      'created_time': formatter.format(created_time),
////      'modified_time': formatter.format(modified_time)
//    };
//  }
//
//  UnmodifiableListView<NoteItem> get allTasks =>
//      UnmodifiableListView(this.contents);
}
