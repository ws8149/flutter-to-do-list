import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveTodoList () async {

  }


}