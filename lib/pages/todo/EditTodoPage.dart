import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AppNavBar.dart';
import '../../components/AppScaffold.dart';
import '../../components/DatePicker.dart';
import '../../helpers/DateTimeHelpers.dart';
import 'HomePage.dart';


class EditTodoPage extends StatefulWidget {
  final int id;
  final dynamic todoItem;

  EditTodoPage({required this.id, this.todoItem});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  String? _title ;

  String? _start_date;
  DateTime? _start_date_time;
  String? _display_start_date;

  String? _end_date;
  DateTime? _end_date_time;
  String? _display_end_date;

  Future<void> saveTodo () async {
    // Save data locally
    try {
      // Get latest todos list from prefs
      print("Get latest todos list from prefs");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String prefs_todos = prefs.getString('TODO_ITEMS') ?? '';

      List<dynamic> todos = [];

      if (prefs_todos != '') {
        todos = jsonDecode(prefs_todos);
      }

      // Update todos list
      print("Update todos list");
      // Calculate time left
      String time_left = calculateTimeLeft(_start_date_time!, _end_date_time!);

      dynamic new_todo = {
        "id": widget.id,
        "title": _title,
        "start_date": _start_date,
        "display_start_date": _display_start_date,
        "end_date": _end_date,
        "display_end_date": _display_end_date,
        "time_left": time_left,
        "is_complete": false,
      };

      todos[widget.id] = new_todo;

      // Save todos list
      print("Save todos list");
      prefs.setString('TODO_ITEMS', jsonEncode(todos));

      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    } catch (err) {
      print("error adding new todo");
      print(err);
    }
  }

  Future<void> initEditTodoPage() async {
    dynamic todoItem = widget.todoItem;

    print('init todo page..');

    print(todoItem);


    if (todoItem != null) {
      setState(() {
        _title = todoItem["title"];

        _start_date = todoItem["start_date"];
        _start_date_time = convertDateStringToDateTime(todoItem["start_date"]);
        _display_start_date = todoItem["display_start_date"];

        _end_date = todoItem["end_date"];
        _end_date_time = convertDateStringToDateTime(todoItem["end_date"]);
        _display_end_date = todoItem["display_end_date"];
      });
    }


  }

  @override
  void initState() {
    super.initState();
    initEditTodoPage();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppNavBar(
        label: 'Edit To-Do List',
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To-Do Title'),

            const SizedBox(height: 10),

            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                hintText: 'Please key in your To-Do Title here.',
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                counterText: '',
                contentPadding: EdgeInsets.only(top: 10, left: 10),
              ),
              maxLength: 100,
              minLines: 1,
              maxLines: 10,
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Text('Start Date'),

            const SizedBox(height: 10),

            DatePicker(
              onSelect: (DateTime selectedDate, String displayDate) {
                setState(() {
                  _start_date_time = selectedDate;
                  _start_date = selectedDate.toString();
                  _display_start_date = displayDate;
                });
              },
              selectedDate: convertDateStringToDateTime(_start_date),
            ),

            const SizedBox(height: 20),

            Text('Estimate End Date'),

            const SizedBox(height: 10),

            DatePicker(
              onSelect: (DateTime selectedDate, String displayDate) {
                setState(() {
                  _end_date_time = selectedDate;
                  _end_date = selectedDate.toString();
                  _display_end_date = displayDate;
                });
              },
              selectedDate: convertDateStringToDateTime(_end_date),
            ),

            SizedBox(height: 20),

            InkWell(
              onTap: () async {
                saveTodo();
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  color: Colors.black,
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text('Save', style: TextStyle(color: Colors.white),)
              ),
            )
          ],

        ),
      ),

    );
  }
}
