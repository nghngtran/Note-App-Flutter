import 'package:intl/intl.dart';
import 'package:note_app/utils/database/model/TimeUtils.dart';

import 'noteItem.dart';
import 'tag.dart';

//@entity
class Note extends TimeUtils {
  static int order = 0;

  //@primaryKey
  final String id;
  String title;
  List<Tag> tags;
  List<NoteItem> contents;
  List<String> history;

  //Constructor
  Note(this.id) : super() {
    //this.id = "note"+ ((++order) as String);
    this.title = "New Note";
    this.tags = new List<Tag>();
    this.history = new List<String>();
    this.history.add(DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()));
  }

  Note.withTitle(String title, this.id) {
    Note(id);
    this.title = title;
  }

  Note.withTag(Tag tag, this.id) {
    Note(id);
    this.tags.add(tag);
  }

  //Set Attribute
  void setTitle(String title) {
    this.title = title;
  }

  void removeTitle() {
    this.title = "New Note";
  }

  void setTag(List<Tag> tags) {
    this.tags.addAll(tags);
    //this.tags = this.tags.toSet().toList();
  }

  void removeTag(List<Tag> tags) {
    tags.forEach((element) => this.tags.remove(element));
  }

  void addNoteItem(NoteItem noteItem) {
    this.contents.add(noteItem);
  }

  void removeNoteItem(NoteItem noteItem) {
    this.contents.remove(noteItem);
  }

  NoteItem getNoteItemAt(index) {
    return this.contents[index];
  }

  Map<String, dynamic> toMap(Tag tag) {
    return {
      'note_id': id,
      'title': title,
      'tag_id': tag.id,
      'created_time': created_time,
      'modified_time': modified_time
    };
  }
}
