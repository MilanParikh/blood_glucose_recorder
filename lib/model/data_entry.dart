class DataEntry {
  DateTime date;
  String time;
  String concentration;
  String comment;

  DataEntry(this.date, this.time, this.concentration, this.comment);

  toJson() {
    DateTime dateTime = new DateTime.now();
    return {
      "date": date.toString(),
      "time": time,
      "concentration": concentration,
      "comment": comment,
      "id": dateTime.millisecondsSinceEpoch * -1,
    };
  }
}