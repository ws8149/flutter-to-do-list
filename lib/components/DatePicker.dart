import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function onSelect;

  DatePicker({required this.onSelect, this.selectedDate});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  String? dateText;

  Future<void> openBottomSheet(BuildContext context, Widget child, {double? height}) {
    return showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13),
              topRight: Radius.circular(13)
          )
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Container(
          height: height ?? MediaQuery.of(context).size.height / 2.5,
          child: child
      ),
    );
  }

  Widget datetimePicker(BuildContext context) {
    DateTime? selectedDate;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                selectedDate = newDate;
              },
              minimumYear: 2000,
              maximumYear: DateTime.now().year,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
          CupertinoButton(
            child: Text('OK'),
            onPressed: () {
              // Select current date for user by default
              selectedDate = selectedDate ?? DateTime.now();

              setState(() {
                dateText = selectedDate!.day.toString() + '/' +
                    selectedDate!.month.toString() + '/' +
                    selectedDate!.year.toString();
              });

              Navigator.of(context).pop();

              widget.onSelect(selectedDate);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
        onPressed: () { openBottomSheet(context, datetimePicker(context)); },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(dateText ?? 'Select a date', style: TextStyle(color: Colors.black45) )
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black45)
          ],
        ),
      ),
    );
  }
}