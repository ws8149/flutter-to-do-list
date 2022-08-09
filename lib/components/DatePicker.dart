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

  Widget showErrorText (FormFieldState<DateTime> formState, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: (
          Text(
            formState.errorText!,
            style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12)
          )
        ),
      ),
    );
  }

  Future<void> pickDate (FormFieldState<DateTime> formState) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100) , //
    );

    String formattedDateText = formatDateTimeForDisplay(selectedDate);

    setState(() {
      dateText = formattedDateText;
    });

    widget.onSelect(selectedDate, formattedDateText);
    formState.setValue(selectedDate);
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
        late BorderSide border_style;

        if (formState.hasError) {
          border_style = BorderSide(
            color: Theme.of(context).errorColor,
            style: BorderStyle.solid,
            width: 1,
          );
        } else {
          border_style = BorderSide(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 0.5,
          );
        }

        return Column(
          children: [
            (
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: border_style,
                    ),
                    onPressed: () async {
                      pickDate(formState);
                    },
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