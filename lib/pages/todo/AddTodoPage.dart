
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/storage/LocalStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/AppNavBar.dart';
import '../../components/AppScaffold.dart';
import '../../components/DatePicker.dart';
import '../../helpers/DateTimeHelpers.dart';
import '../../models/AppDate.dart';


class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key, required int currentId}) : super(key: key);

  final int currentId = 0;

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String? _title;

  AppDate? _start_app_date;
  AppDate? _end_app_date;

  // For calculating time left
  DateTime? _start_date_time;
  DateTime? _end_date_time;

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
              selectedDate: _start_date_time,
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
              selectedDate: _end_date_time,
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
                LocalStorage localStorage = LocalStorage();
                await localStorage.saveTodo(
                  widget.currentId,
                  _title!,
                  _start_app_date!,
                  _end_app_date!,
                  _start_date_time!,
                  _end_date_time!
                );
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
