
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

String formatDateTimeForDisplay (DateTime? dateTime) {
  String output = '';

  try {
    output = (dateTime?.day.toString() ?? '')
        + "/" + (dateTime?.month.toString() ?? '')
        + "/" + (dateTime?.year.toString() ?? '');
  } catch (err) {
    print('Error formatting date time for display');
  }

  return output;
}

/**
 * Calculates remaining time left based on end date provided and returns a string.
 *
 */
String calculateTimeLeft (DateTime startDateTime, DateTime endDateTime) {
  String time_left = "";

  try {
    Duration duration = endDateTime.difference(startDateTime);

    String days = duration.inDays.toString();

    if (duration.inDays == 1) {
      time_left = "${days} day";
    } else {
      time_left = "${days} days";
    }

  } catch (err) {
    print('Error calculating time left: $err');
  }

  return time_left;
}