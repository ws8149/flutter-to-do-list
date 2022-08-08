
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