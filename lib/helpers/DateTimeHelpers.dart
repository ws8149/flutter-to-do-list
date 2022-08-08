
DateTime? convertDateStringToDateTime (String? dateStr) {
  DateTime? output;

  if (dateStr != null) {
    try {
      output = DateTime.parse(dateStr);
    } catch (err) {
      print('Error converting date string');
    }
  }

  return output;
}

String formatDateTimeForDisplay (DateTime dateTime) {
  String output = '';

  try {
    output = dateTime.day.toString() + " " + dateTime.month.toString() + " " + dateTime.year.toString();
  } catch (err) {
    print('Error formatting date time for display');
  }

  return output;
}

String calculateTimeLeft (String endDateStr) {
  DateTime? end_date_time = convertDateStringToDateTime(endDateStr);

  // Calculate time left
  String time_left = "";

  try {
    Duration duration = end_date_time!.difference(DateTime.now());

    if (duration.inHours > 23) {
      time_left = "${duration.inHours.toString()} hrs";
    } else {
      time_left = "${duration.inDays.toString()} days";
    }

  } catch (err) {
    print('Error calculating time left: $err');
  }

  return time_left;
}