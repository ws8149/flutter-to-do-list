
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

/**
 * Calculates remaining time left based on end date provided.
 *
 */
String calculateTimeLeft (String endDateStr) {
  DateTime? end_date_time = convertDateStringToDateTime(endDateStr);

  String time_left = "";

  try {
    Duration duration = end_date_time!.difference(DateTime.now());

    // Reduce by 1 day because we plan to show the remaining hours as well
    String days = (duration.inDays - 1).toString();

    String hours = duration.inHours.toString();
    String mins = (duration.inMinutes - duration.inHours * 60).toString();

    if (duration.inHours > 23) {
      hours = (duration.inHours - duration.inDays * 24).toString();
      time_left = "${days} days ${hours} hrs";
    } else {
      time_left = "${hours} hrs ${mins} mins";
    }

  } catch (err) {
    print('Error calculating time left: $err');
  }

  return time_left;
}