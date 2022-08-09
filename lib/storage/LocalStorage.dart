import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/DateTimeHelpers.dart';
import '../models/AppDate.dart';
import '../models/Todo.dart';

/**
 * For saving and retrieving todo_list items locally
 */
class LocalStorage {
  List<Todo> _todoList = [];

  List<Todo> getTodoList() {
    return _todoList;
  }

  Future<void> loadTodoList () async {
    List<Todo> todoList = [];

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String prefsTodos = prefs.getString('TODO_ITEMS') ?? '';

      List<dynamic> jsonList = [];

      if (prefsTodos != '') {
        jsonList = jsonDecode(prefsTodos);
      }

      for (var json in jsonList) {
        Todo todo = Todo.fromJson(json);

        todoList.add(todo);
      }



    } catch (err) {
      print('Error getting todo list from local storage: $err');
    }

    _todoList = todoList;
  }

  Future<void> saveTodo (
      int id,
      String title,
      AppDate startAppDate,
      AppDate endAppDate,
      DateTime startDateTime,
      DateTime endDateTime
  ) async {
      try {
        // Get latest todos list from prefs
        print("Get latest todos list from prefs");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String prefs_todos = prefs.getString('TODO_ITEMS') ?? '';

        List<dynamic> todos = [];

        if (prefs_todos != '') {
          todos = jsonDecode(prefs_todos);
        }

        // Calculate time left
        String timeLeft = calculateTimeLeft(startDateTime, endDateTime);

        // Update todos list
        print("Update todos list");
        dynamic new_todo = {
          "id": id,
          "title": title,
          "start_app_date": startAppDate,
          "end_app_date": endAppDate,
          "time_left": timeLeft,
          "is_complete": false,
        };

        print('adding new todo..');
        print(new_todo);

        todos.add(new_todo);

        // Save todos list
        print("Save todos list");
        prefs.setString('TODO_ITEMS', jsonEncode(todos));


      } catch (err) {
        print("error adding new todo");
        print(err);
      }
  }

  Future<void> updateTodo (
      int id,
      String title,
      AppDate startAppDate,
      AppDate endAppDate,
      DateTime startDateTime,
      DateTime endDateTime
    ) async {

      try {
        // Get latest todos list from prefs
        print("Get latest todos list from prefs");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String prefs_todos = prefs.getString('TODO_ITEMS') ?? '';

        List<dynamic> todos = [];

        if (prefs_todos != '') {
          todos = jsonDecode(prefs_todos);
        }

        // Calculate time left
        String timeLeft = calculateTimeLeft(startDateTime, endDateTime);

        // Update todos list
        print("Update todos list");
        dynamic new_todo = {
          "id": id,
          "title": title,
          "start_app_date": startAppDate,
          "end_app_date": endAppDate,
          "time_left": timeLeft,
          "is_complete": false,
        };

        print('updating todo..');
        todos[id] = new_todo;

        // Save todos list
        print("Save todos list");
        prefs.setString('TODO_ITEMS', jsonEncode(todos));

      } catch (err) {
        print("error adding new todo");
        print(err);
      }
  }


  Future<void> deleteTodo ( int id ) async {
    // Get latest todos list from prefs
    print("Get latest todos list from prefs");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefs_todos = prefs.getString('TODO_ITEMS') ?? '';

    List<dynamic> todos = [];

    if (prefs_todos != '') {
      todos = jsonDecode(prefs_todos);
    }

    todos.removeAt(id);

    prefs.setString('TODO_ITEMS', jsonEncode(todos));
  }

}