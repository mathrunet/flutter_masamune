part of katana;

/// Provides general extensions to [DateTime].
extension DateTimeExtensions on DateTime {
  /// True if the specified time or the current time is the same day.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isToday([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day;
  }

  /// True if the specified time or the current time is the same month.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isThisMonth([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year && month == dateTime.month;
  }

  /// True if the specified time or the current time is the same year.
  ///
  /// [dateTime]: Time to compare.
  bool isThisYear([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year;
  }

  /// True if the specified time or the current time is the same hour.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isThisHour([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour;
  }

  /// True if the specified time or the current time is the same minute.
  ///
  /// [dateTime]: Time to compare.
  bool isThisMimute([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute;
  }

  /// True if the specified time or the current time is the same second.
  ///
  /// Pass the date and time you want to compare to [dateTime].
  /// If it is not passed, the current date and time is used.
  bool isThisSecond([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute &&
        second == dateTime.second;
  }

  /// Format and output the date.
  ///
  /// Enter the format of the date and time in [format].
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return DateFormat(format).format(this).replaceAll(
          "ww",
          weekNumber.toString().padLeft(2, "0"),
        );
  }

  /// Extract date only.
  DateTime toDate() {
    return DateTime(year, month, day);
  }

  /// Converts a DateTime to a DateID in yyyyMMdd format.
  String toDateID() {
    return format("yyyyMMdd");
  }

  /// Converts a DateTime to a DateTimeID in yyyyMMddHHmmss format.
  String toDateTimeID() {
    return format("yyyyMMddHHmmss");
  }

  /// Rounds DateTime with Duration.
  DateTime round(Duration d) {
    return DateTime.fromMicrosecondsSinceEpoch(
      (microsecondsSinceEpoch / d.inMicroseconds).round() * d.inMicroseconds,
    );
  }

  /// Ceil DateTime with Duration.
  DateTime ceil(Duration d) {
    return DateTime.fromMicrosecondsSinceEpoch(
      (microsecondsSinceEpoch / d.inMicroseconds).ceil() * d.inMicroseconds,
    );
  }

  /// Floor DateTime with Duration.
  DateTime floor(Duration d) {
    return DateTime.fromMicrosecondsSinceEpoch(
      (microsecondsSinceEpoch / d.inMicroseconds).floor() * d.inMicroseconds,
    );
  }

  /// Week number according to ISO 8601.
  int get weekNumber {
    final thursday = DateTime.fromMillisecondsSinceEpoch(
      ((millisecondsSinceEpoch - 259200000) / 604800000).ceil() * 604800000,
    );
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    return ((thursday.millisecondsSinceEpoch -
                    firstDayOfYear.millisecondsSinceEpoch) /
                604800000)
            .floor() +
        1;
  }

  /// Convert string data that is UTC but UTC is not specified to local time while forcing the data to be treated as UTC.
  DateTime? toUnUtc() {
    return DateTime.tryParse("${toIso8601String().trimStringRight("Z")}Z")
        ?.toLocal();
  }
}
