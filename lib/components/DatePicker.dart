import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/DateTimeHelpers.dart';

class DatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function onSelect;

  DatePicker({
    Key? key,
    required this.onSelect,
    this.selectedDate,
  });

  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  String? dateText;

  void initDatePicker () {
    String formattedDateText = formatDateTimeForDisplay(widget.selectedDate);

    if (widget.selectedDate != null) {
      setState(() {
        dateText = formattedDateText;
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

  Widget datetimePicker(FormFieldState<DateTime> formState, BuildContext context) {
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
              minimumYear: DateTime.now().year,
              maximumYear: DateTime.now().year + 1,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
          CupertinoButton(
            child: Text('OK'),
            onPressed: () {
              // Select current date for user by default
              selectedDate = selectedDate ?? DateTime.now();

              String formattedDateText = formatDateTimeForDisplay(selectedDate);

              setState(() {
                dateText = formattedDateText;
              });

              Navigator.of(context).pop();

              widget.onSelect(selectedDate, formattedDateText);
              formState.setValue(selectedDate);

            },
          )
        ],
      ),
    );
  }

  Widget showErrorText (FormFieldState<DateTime> formState, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: (
          Text(
            formState.errorText!,
            style: TextStyle(color: Colors.red, fontSize: 12)
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.selectedDate,
      validator: (value) {
        if (value == null) {
          return 'Date required';
        }
      },
      builder: (formState) {
        late Color border_color;

        if (formState.hasError) {
          border_color = Colors.red;
        } else {
          border_color = Colors.black;
        }

        return Column(
          children: [
            (
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: border_color,
                        style: BorderStyle.solid,
                        width: 0.5,
                      ),
                    ),
                    onPressed: () { openBottomSheet(context, datetimePicker(formState, context)); },
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
                )
            ),
            if (formState.hasError) showErrorText(formState, context)
          ],
        );
      },

    );
  }
}