import 'package:note_app/utils/database/model/TimeUtils.dart';

enum NoteItemType { TEXT, IMAGE, AUDIO }

class NoteItem extends TimeUtils {
  static int order = 0;

  //@primaryKey
  final String id;
  final String note_id;
  String content;
  final NoteItemType type;
  String textColor;
  String bgColor;

  NoteItem(this.id, this.note_id, this.type) : super();

  NoteItem.withFullInfo(
      this.id,
      this.note_id,
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

  Map<String, dynamic> toMap() {
    return {
      'noteItem_id': id,
      'note_id': note_id,
      'type': type,
      'content': content,
      'textColor': textColor,
      'bgColor': bgColor,
      'created_time': created_time,
      'modified_time': modified_time
    };
  }
}
