import 'package:note_app/utils/database/model/TimeUtils.dart';
import 'package:intl/intl.dart';
class Tag extends TimeUtils {
  static int order = 0;

  //@primaryKey
  final String id;
  String title;
  String color;

  Tag(this.id) : super() {
    //this.id = "tag"+ ((++order) as String);
    this.title = "New Tag";
  }

  Tag.withFullInfo(this.id, this.title, this.color
      , DateTime created_time,
      DateTime modified_time) {
    this.created_time = created_time;
    this.modified_time = modified_time;
  }
  Tag.withTitle(String title, this.id) {
    Tag(id);
    this.title = title;
  }
  String toString(){
    return "id:"+this.id+" title:"+this.title+" created:"+this.created_time.toString()+" modified:"+this.modified_time.toString();
  }
  Map<String, dynamic> toMap() {
    var formatter = new DateFormat('y-MM-d HH:mm:ss.sss');
    return {
      'tag_id': id,
      'title': title,
      'color': color,
      'created_time': formatter.format(created_time),
      'modified_time': formatter.format(modified_time)
    };
  }
}
