import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_to_do_list/helpers/DateTimeHelpers.dart';
import 'package:flutter_to_do_list/models/AppDate.dart';
import 'package:flutter_to_do_list/models/Todo.dart';

import './StorageKeys.dart';

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
      String prefsTodos = prefs.getString(StorageKeys.TODO_ITEMS) ?? '';

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String prefs_todos = prefs.getString(StorageKeys.TODO_ITEMS) ?? '';

        List<dynamic> todos = [];

        if (prefs_todos != '') {
          todos = jsonDecode(prefs_todos);
        }

        // Calculate time left
        String timeLeft = calculateTimeLeft(startDateTime, endDateTime);

        // Update todos list
        dynamic new_todo = {
          "id": id,
          "title": title,
          "start_app_date": startAppDate,
          "end_app_date": endAppDate,
          "time_left": timeLeft,
          "is_complete": false,
        };


        todos.add(new_todo);

        // Save todos list
        prefs.setString(StorageKeys.TODO_ITEMS, jsonEncode(todos));


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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String prefs_todos = prefs.getString(StorageKeys.TODO_ITEMS) ?? '';

        List<dynamic> todos = [];

        if (prefs_todos != '') {
          todos = jsonDecode(prefs_todos);
        }

        // Calculate time left
        String timeLeft = calculateTimeLeft(startDateTime, endDateTime);

        // Update todos list
        dynamic new_todo = {
          "id": id,
          "title": title,
          "start_app_date": startAppDate,
          "end_app_date": endAppDate,
          "time_left": timeLeft,
          "is_complete": false,
        };

        todos[id] = new_todo;

        // Save todos list
        prefs.setString(StorageKeys.TODO_ITEMS, jsonEncode(todos));

      } catch (err) {
        print("error adding new todo");
        print(err);
      }
  }


  Future<void> deleteTodo ( int id ) async {
    // Get latest todos list from prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefs_todos = prefs.getString(StorageKeys.TODO_ITEMS) ?? '';

    List<dynamic> todos = [];

    if (prefs_todos != '') {
      todos = jsonDecode(prefs_todos);
    }

    print('removing id: $id');

    todos.removeAt(id);

    prefs.setString(StorageKeys.TODO_ITEMS, jsonEncode(todos));
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}