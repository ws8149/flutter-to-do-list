
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