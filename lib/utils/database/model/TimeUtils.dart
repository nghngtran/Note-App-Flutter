abstract class TimeUtils{
  DateTime created_time;
  DateTime modified_time;
  TimeUtils(){
    DateTime now = DateTime.now();
    this.created_time = now;
    this.modified_time = now;
  }
  void updateModify(){
    this.modified_time = DateTime.now();
  }
}