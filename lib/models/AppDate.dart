class AppDate {
  String? dateTimeString;
  String? displayDate;

  AppDate(String this.dateTimeString, String this.displayDate);

  AppDate.fromJson(Map<String, dynamic> json) {
    dateTimeString = json['date_time_string'];
    displayDate = json['display_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_time_string'] = this.dateTimeString;
    data['display_date'] = this.displayDate;
    return data;
  }

  @override
  String toString() {
    return 'AppDate{dateTimeString: $dateTimeString, displayDate: $displayDate}';
  }
}