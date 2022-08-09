
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/helpers/AlertHelper.dart';
import 'package:flutter_to_do_list/storage/LocalStorage.dart';
import 'package:flutter_to_do_list/components/AppNavBar.dart';
import 'package:flutter_to_do_list/components/AppScaffold.dart';
import 'package:flutter_to_do_list/components/DatePicker.dart';
import 'package:flutter_to_do_list/models/AppDate.dart';


class AddTodoPage extends StatefulWidget {
  final int currentId;
  const AddTodoPage({Key? key, required this.currentId}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isValidationTriggered = false;

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
      body: Form(
        key: _formKey,
        autovalidateMode: _isValidationTriggered ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Input required';
                        }

                        return null;
                      },
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
                setState(() { _isValidationTriggered = true; });

                if (_formKey.currentState!.validate()) {

                  if (_start_date_time!.isAfter(_end_date_time!)) {
                    showAlert("Start date must be before end date.", context);
                    return;
                  }

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
                }

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
