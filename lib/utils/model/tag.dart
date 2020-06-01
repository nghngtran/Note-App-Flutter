import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:note_app/utils/model/TimeUtils.dart';

class Tag extends TimeUtils with ChangeNotifier {
  static int order = 0;

  //@primaryKey
  String id;
  String title;
  Color color;

  Tag() : super() {
    this.id = "tag" + ((++order).toString());
    this.title = "New Tag";
  }
//  String toString() {
//    return title;
//  }

  Tag.withFullInfo(this.id, this.title, this.color, DateTime created_time,
      DateTime modified_time) {
    this.created_time = created_time;
    this.modified_time = modified_time;
    notifyListeners();
  }
  Tag.withTitle(String title, this.id) : super() {
    this.id = "tag" + ((++order).toString());
    this.title = title;
  }
  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setColor(Color color) {
    this.color = color;
    notifyListeners();
  }

  Tag getTag() {
    return this;
  }

  String toString() {
    return "<Tag ID=\""+id.toString()+"\" Title=\"" +title.toString()  +
        "\" Color=\"" + color.value.toString() +
        "\" Created_Time=\"" + created_time.toString() +
        "\" Modified_Time=\"" + modified_time.toString()+
        "\"/>";
  }

  Map<String, dynamic> toMap() {
    var formatter = TimeUtils.formatter;
    return {
      'tag_id': id,
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
