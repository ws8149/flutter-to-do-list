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

  void initDatePicker () {
    if (widget.selectedDate != null) {
      setState(() {
        dateText = widget.selectedDate!.day.toString() + '/' +
            widget.selectedDate!.month.toString() + '/' +
            widget.selectedDate!.year.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initDatePicker();
  }

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
          height: height ?? MediaQuery.of(context).size.height / 2,
          child: child
      ),
    );
  }

  Widget datetimePicker(BuildContext context) {
    DateTime? selectedDate = widget.selectedDate;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: selectedDate ?? DateTime.now(),
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

              String formattedDateText = selectedDate!.day.toString() + '/' +
                  selectedDate!.month.toString() + '/' +
                  selectedDate!.year.toString();

              setState(() {
                dateText = formattedDateText;
              });

              Navigator.of(context).pop();

              widget.onSelect(selectedDate, formattedDateText);
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