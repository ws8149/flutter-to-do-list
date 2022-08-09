import 'AppDate.dart';

class Todo {
  int? id;
  String? title;
  AppDate? startAppDate;
  AppDate? endAppDate;
  String? timeLeft;
  bool? isComplete;

  Todo(
      {this.id,
        this.title,
        this.startAppDate,
        this.endAppDate,
        this.timeLeft,
        this.isComplete});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startAppDate = json['start_app_date'] != null
        ? new AppDate.fromJson(json['start_app_date'])
        : null;
    endAppDate = json['end_app_date'] != null
        ? new AppDate.fromJson(json['end_app_date'])
        : null;
    timeLeft = json['time_left'];
    isComplete = json['is_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.startAppDate != null) {
      data['start_app_date'] = this.startAppDate!.toJson();
    }
    if (this.endAppDate != null) {
      data['end_app_date'] = this.endAppDate!.toJson();
    }
    data['time_left'] = this.timeLeft;
    data['is_complete'] = this.isComplete;
    return data;
  }

  @override
  List<Object?> get props => [id, title, startAppDate, endAppDate, timeLeft, isComplete];


}
