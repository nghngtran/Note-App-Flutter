import 'package:note_app/utils/database/model/TimeUtils.dart';

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
//    this.created_time = created_time;
//    this.modified_time = modified_time;
  }

  Tag.withTitle(String title, this.id) {
    Tag(id);
    this.title = title;
  }

  Map<String, dynamic> toMap() {
    return {
      'tag_id': id,
      'title': title,
      'color': color,
//      'created_time': created_time,
//      'modified_time': modified_time
    };
  }
}
