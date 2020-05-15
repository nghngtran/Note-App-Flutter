import 'package:note_app/utils/database/model/TimeUtils.dart';

enum NoteItemType { TEXT, IMAGE, AUDIO }

class NoteItem extends TimeUtils {
  static int order = 0;

  //@primaryKey
  String id;
  String content;
  String type;
  String textColor;
  String bgColor;

  NoteItem(this.type) : super() {
    this.id = "noteItem" + ((++order).toString());
  }

  NoteItem.withFullInfo(this.id,
      this.type,
      this.content,
      this.textColor,
      this.bgColor,
      DateTime created_time,
      DateTime modified_time) {
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

  void setBgColor(String color) {
    this.bgColor = color;
  }

  String toString() {
    return id.toString() + "  |  " +
        type.toString() +" | "+
        content.toString() + "  |  " +
        bgColor.toString() + "  |  " +
        textColor.toString() + "  |  " +
        created_time.toString() + "  |  " +
        modified_time.toString();
  }

  Map<String, dynamic> toMap(String note_id) {
    var formatter = TimeUtils.formatter;
    return {
      'noteItem_id': id,
      'note_id': note_id,
      'type': type,
      'content': content,
      'textColor': textColor,
      'bgColor': bgColor,
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
      'bgColor': bgColor,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }
}