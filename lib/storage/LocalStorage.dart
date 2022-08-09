import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_to_do_list/helpers/DateTimeHelpers.dart';
import 'package:flutter_to_do_list/models/AppDate.dart';
import 'package:flutter_to_do_list/models/Todo.dart';

import './StorageKeys.dart';

/**
 * Handles all data storage logic
 */
class LocalStorage {
  List<Todo> _todoList = [];

  List<Todo> getTodoList() {
    return _todoList;
  }

   /*
   * Private function to get data from prefs and to decode for later use
   */
  Future<List> _getJsonList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefsTodos = prefs.getString(StorageKeys.TODO_ITEMS) ?? '';

    List<dynamic> jsonList = [];

    if (prefsTodos != '') {
      jsonList = jsonDecode(prefsTodos);
    }

    return jsonList;
  }

  /**
   * Load data from prefs into type defined _todoList variable
   */
  Future<void> loadTodoList () async {
    List<Todo> todoList = [];

    List<dynamic> jsonList = await _getJsonList();

    for (var json in jsonList) {
      Todo todo = Todo.fromJson(json);
      todoList.add(todo);
    }

    _todoList = todoList;
  }

  /**
   * Save new to-do data to locally
   */
  Future<void> saveTodo (
      int id,
      String title,
      AppDate startAppDate,
      AppDate endAppDate,
      DateTime startDateTime,
      DateTime endDateTime
  ) async {
      try {
        // Get latest data
        List<dynamic> todos = await _getJsonList();

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(StorageKeys.TODO_ITEMS, jsonEncode(todos));

      } catch (err) {
        print("error adding new todo");
        print(err);
      }
  }

  /**
   * Update to-do data locally
   */
  Future<void> updateTodo (
      int id,
      String title,
      AppDate startAppDate,
      AppDate endAppDate,
      DateTime startDateTime,
      DateTime endDateTime
    ) async {

      try {
        // Get latest data
        List<dynamic> todos = await _getJsonList();

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(StorageKeys.TODO_ITEMS, jsonEncode(todos));

      } catch (err) {
        print("error adding new todo");
        print(err);
      }
  }


  /**
   * Delete to-do data from local storage
   */
  Future<void> deleteTodo ( int id ) async {
    // Get latest data
    List<dynamic> todos = await _getJsonList();

    // Remove item at index
    todos.removeAt(id);

    // Save todos list
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(StorageKeys.TODO_ITEMS, jsonEncode(todos));
  }

  /**
   * Clear local storage
   */
  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}