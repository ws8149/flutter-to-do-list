import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AppNavBar.dart';
import '../../components/AppScaffold.dart';
import '../../components/DatePicker.dart';
import '../../helpers/DateTimeHelpers.dart';
import '../../models/AppDate.dart';
import 'HomePage.dart';


class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key, required int current_id}) : super(key: key);

  final int current_id = 0;

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String? _title;

  AppDate? _start_app_date;
  AppDate? _end_app_date;

  DateTime? _start_date_time;
  DateTime? _end_date_time;


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
      
      // Calculate time left
      String time_left = calculateTimeLeft(_start_date_time!, _end_date_time!);

      // Update todos list
      print("Update todos list");
      dynamic new_todo = {
        "id": widget.current_id,
        "title": _title,
        "start_app_date": _start_app_date,
        "end_app_date": _end_app_date,
        "time_left": time_left,
        "is_complete": false,
      };

      print('adding new todo..');
      print(new_todo);

      todos.add(new_todo);

      // Save todos list
      print("Save todos list");
      prefs.setString('TODO_ITEMS', jsonEncode(todos));

      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    } catch (err) {
      print("error adding new todo");
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppNavBar(
        label: 'Add New To-Do List',
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To-Do Title'),

            const SizedBox(height: 10),

            TextFormField(
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
                AppDate selected_app_date = AppDate(selectedDate.toString(), displayDate);

                setState(() {
                  _start_app_date = selected_app_date;
                  _start_date_time = selectedDate;
                });
              },
              selectedDate: convertDateStringToDateTime(_start_app_date?.dateTimeString),
            ),

            const SizedBox(height: 20),

            Text('Estimate End Date'),

            const SizedBox(height: 10),

            DatePicker(
              onSelect: (DateTime selectedDate, String displayDate) {
                AppDate selected_app_date = AppDate(selectedDate.toString(), displayDate);

                setState(() {
                  _end_app_date = selected_app_date;
                  _end_date_time = selectedDate;
                });
              },
              selectedDate: convertDateStringToDateTime(_end_app_date?.dateTimeString),
            ),

            SizedBox(height: 20),

            InkWell(
              onTap: () async {

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                print('Cleared');
              },
              child: Container(
                color: Colors.grey,
                padding: const EdgeInsets.all(20.0),
                child: Text('Clear Shared Preferences'),
              ),
            ),

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
                  child: Text('Create Now', style: TextStyle(color: Colors.white),)
              ),
            )
          ],

        ),
      ),

    );
  }
}
