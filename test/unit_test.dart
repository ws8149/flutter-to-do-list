import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_to_do_list/helpers/DateTimeHelpers.dart';
import 'package:flutter_to_do_list/models/AppDate.dart';
import 'package:flutter_to_do_list/models/Todo.dart';
import 'package:flutter_to_do_list/storage/LocalStorage.dart';

void main() {
  late LocalStorage localStorage;

  setUp(() {
    localStorage = LocalStorage();
  });

  tearDown(() {
    localStorage.clear();
  });

  test("Init empty list", () {
    expect(localStorage.getTodoList().length, 0);
  });

  test("Todo added", () async {
    DateTime todayDate = DateTime.now();
    DateTime tomorrowDate = DateTime.now().add(Duration(days: 1));

    String startDisplayDate = formatDateTimeForDisplay(todayDate);
    AppDate startAppDate = AppDate(todayDate.toString(), startDisplayDate);

    String endDisplayDate = formatDateTimeForDisplay(tomorrowDate);
    AppDate endAppDate = AppDate(todayDate.toString(), endDisplayDate);

    await localStorage.saveTodo(1, 'Sample Title', startAppDate, endAppDate, todayDate, tomorrowDate);

    await localStorage.loadTodoList();

    List<Todo> todoList = localStorage.getTodoList();

    expect(todoList.length, 1);
    expect(todoList[0].id, 1);
  });


}