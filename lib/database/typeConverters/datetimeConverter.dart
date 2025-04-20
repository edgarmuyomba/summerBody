class DateTimeConverter {
  static DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  static int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}
