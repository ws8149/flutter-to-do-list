import 'package:flutter/material.dart';
import '../../components/AppNavBar.dart';
import '../../components/AppScaffold.dart';
import '../../components/DatePicker.dart';
import '../../helpers/DateTimeHelpers.dart';
import '../../models/AppDate.dart';
import '../../models/Todo.dart';
import '../../storage/LocalStorage.dart';


class EditTodoPage extends StatefulWidget {
  final int id;
  final Todo todoItem;

  EditTodoPage({required this.id, required this.todoItem});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  String? _title;

  AppDate? _start_app_date;
  AppDate? _end_app_date;

  // For calculating time left
  DateTime? _start_date_time;
  DateTime? _end_date_time;

  Future<void> initEditTodoPage() async {
    dynamic todoItem = widget.todoItem;

    print('init todo page..');
    print(todoItem);

    AppDate startAppDate = widget.todoItem.startAppDate!;
    AppDate endAppDate = widget.todoItem.endAppDate!;
    DateTime? startDateTime = convertDateStringToDateTime(startAppDate.dateTimeString);
    DateTime? endDateTime = convertDateStringToDateTime(endAppDate.dateTimeString);

    setState(() {
      _title = widget.todoItem.title!;
      _start_app_date = startAppDate;
      _end_app_date = endAppDate;
      _start_date_time = startDateTime;
      _end_date_time = endDateTime;
    });



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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To-Do Title'),

                const SizedBox(height: 10),

                SizedBox(
                  height: 80,
                  child: TextFormField(
                    initialValue: _title,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: 'Please key in your To-Do Title here.',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                      counterText: '',
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                    ),
                    maxLines: null,
                    minLines: null,
                    maxLength: 100,
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                  ),
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
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () async {
              LocalStorage localStorage = LocalStorage();
              await localStorage.updateTodo(
                  widget.id,
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
                child: Text('Save', style: TextStyle(color: Colors.white),)
            ),
          )
        ],
      ),

    );
  }
}
