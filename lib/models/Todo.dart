import 'AppDate.dart';

class Todo {
  int? id;
  String? title;
  AppDate? start;
  AppDate? end;
  String? timeLeft;
  bool? isComplete;

  Todo(
      {this.id,
        this.title,
        this.start,
        this.end,
        this.timeLeft,
        this.isComplete});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    start = json['app_date'] != null
        ? new AppDate.fromJson(json['app_date'])
        : null;
    end = json['end'] != null ? new AppDate.fromJson(json['end']) : null;
    timeLeft = json['time_left'];
    isComplete = json['is_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.start != null) {
      data['app_date'] = this.start!.toJson();
    }
    if (this.end != null) {
      data['end'] = this.end!.toJson();
    }
    data['time_left'] = this.timeLeft;
    data['is_complete'] = this.isComplete;
    return data;
  }
}