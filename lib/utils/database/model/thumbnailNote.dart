import 'package:note_app/utils/database/model/TimeUtils.dart';
import 'package:note_app/utils/database/model/tag.dart';

class ThumbnailNote{
  final String note_id;
  final String title;
  List<Tag> tags;
  final String content;
  final DateTime modified_time;
  ThumbnailNote(this.note_id, this.title, this.tags, this.content, this.modified_time);
  ThumbnailNote.withOutTag(this.note_id,this.title,this.content,this.modified_time);
  void setTag(List<Tag> tags) {
    this.tags.addAll(tags);
  }
  String toString(){
    String tag ="";
    if (tags != null) {
      tags.forEach((f) => {
        tag = tag +"\n"+f.toString()
      });
    }
    String text = "[Thumbnail]\nNote_id: "+note_id+
                    "\nTitle: "+title+
                    "\nContent: "+content+
                    "\ntags: "+tag+
                    "\nModified_Time: "+modified_time.toString()+
                  "[/Thumbnail]";
    return text;
  }
  Map<String,dynamic > toMap() {
    var formatter = TimeUtils.formatter;
    return {
      'note_id':note_id,
      'title':title,
      'content':content,
      'modified_time':formatter.format(modified_time)
    };
  }
}
