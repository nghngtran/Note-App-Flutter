import 'package:flutter/cupertino.dart';
import 'package:note_app/utils/model/TimeUtils.dart';

class Tag extends TimeUtils with ChangeNotifier {

  //@primaryKey
  int id;
  String title;
  Color color;

  Tag() : super() {
    this.title = "New Tag";
  }

  Tag.withFullInfo(this.id, this.title, this.color, DateTime createdTime,
      DateTime modifiedTime) {
    this.created_time = createdTime;
    this.modified_time = modifiedTime;
    notifyListeners();
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setColor(Color color) {
    this.color = color;
    notifyListeners();
  }

//  Tag getTag() {
//    return this;
//  }

  String toString() {
    return "<Tag ID=\""+id.toString()+"\" Title=\"" +title.toString()  +
        "\" Color=\"" + color.value.toString() +
        "\" Created_Time=\"" + created_time.toString() +
        "\" Modified_Time=\"" + modified_time.toString()+
        "\"/>";
  }

  Map<String, dynamic> toDatabaseJson() {
    var formatter = TimeUtils.formatter;
    return {
      'title': title,
      'color': color == null ? 0 : color.value,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }

  factory Tag.fromDatabaseJson(Map<String, dynamic> data) => Tag.withFullInfo(
      data['tag_id'],
      data['title'],
      Color(data['color']),
      DateTime.parse(data['created_time']),
      DateTime.parse(data['modified_time']));
}
