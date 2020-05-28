import 'dart:ui';

import 'package:note_app/utils/database/model/TimeUtils.dart';

enum NoteItemType { TEXT, IMAGE, AUDIO }

class NoteItem extends TimeUtils {
  static int order = 0;

  //@primaryKey
  String id;
  String content;
  String type;
  String textColor;
//  String bgColor;
  Color note_color;
  NoteItem(this.type) : super() {
    this.id = "noteItem" + ((++order).toString());
  }

  NoteItem.withFullInfo(this.id, this.type, this.content, this.textColor,
      this.note_color, DateTime created_time, DateTime modified_time) {
    this.created_time = created_time;
    this.modified_time = modified_time;
  }

  //SetAttribute
  void setContent(String content) {
    this.content = content;
  }

  void setTextColor(String color) {
    this.textColor = color;
  }

  void setBgColor(Color color) {
    this.note_color = color;
  }

  String toString() {
    String text = "[NoteItem]"+"\nID: "+id.toString() +
        "  | Type: " +
        type.toString() +
        " | Content: " +
        content.toString() +
        "  | Color: " +
        note_color.toString() +
        "  | TextColor: " +
        textColor.toString() +
        "  | Created_Time: " +
        created_time.toString() +
        "  | Modified_Time: " +
        modified_time.toString()+
    "\n[/NoteItem]";
  }

  Map<String, dynamic> toMap(String note_id) {
    var formatter = TimeUtils.formatter;
    return {
      'noteItem_id': id,
      'note_id': note_id,
      'type': type,
      'content': content,
      'textColor': textColor,
      'bgColor': note_color.value,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }

  Map<String, dynamic> toMapWithOutNoteID() {
    var formatter = TimeUtils.formatter;
    return {
      'noteItem_id': id,
      'type': type,
      'content': content,
      'textColor': textColor,
      'bgColor': note_color.value,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }
}
