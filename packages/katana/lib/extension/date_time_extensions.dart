part of katana;

/// Provides extended methods for [DateTime].
///
/// [DateTime]用の拡張メソッドを提供します。
extension DateTimeExtensions on DateTime {
  static const List<int> _lengthInMonth = [
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];

  static bool _isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  static int _daysInMonth(int year, int month) =>
      (month == DateTime.february && _isLeapYear(year))
          ? 29
          : _lengthInMonth[month - 1];

  DateTime _addDate(DateDuration duration) {
    var years = year + duration.year;
    years += (month + duration.month) ~/ DateTime.monthsPerYear;
    final months = (month + duration.month) % DateTime.monthsPerYear;
    final days = day + duration.day - 1;
    return DateTime(years, months, 1).add(Duration(days: days));
  }

  DateDuration _differenceDate(DateTime other) {
    int years = other.year - year;
    int months = 0;
    int days = 0;

    if (month > other.month) {
      years -= 1;
      months = DateTime.monthsPerYear + other.month - month;

      if (day > other.day) {
        months -= 1;
        days = _daysInMonth(
              year + years,
              ((month + months - 1) % DateTime.monthsPerYear) + 1,
            ) +
            other.day -
            day;
      } else {
        days = other.day - day;
      }
    } else if (other.month == month) {
      if (day > other.day) {
        years -= 1;
        months = DateTime.monthsPerYear - 1;
        days = _daysInMonth(
              year + years,
              ((month + months - 1) % DateTime.monthsPerYear) + 1,
            ) +
            other.day -
            day;
      } else {
        days = other.day - day;
      }
    } else {
      months = other.month - month;

      if (day > other.day) {
        months -= 1;
        days = _daysInMonth(year + years, month + months) + other.day - day;
      } else {
        days = other.day - day;
      }
    }

    return DateDuration(years, months, days);
  }

  /// Returns `true` if the date is the same as a specific [dateTime] or the current time.
  ///
  /// 特定の[dateTime]もしくは現在時間と同じ日付の場合は`true`を返します
  bool isToday([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day;
  }

  /// Returns `true` if the month is the same as a specific [dateTime] or the current time.
  ///
  /// 特定の[dateTime]もしくは現在時間と同じ月の場合は`true`を返します。
  bool isThisMonth([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year && month == dateTime.month;
  }

  /// Returns `true` if the year is the same as a specific [dateTime] or the current time.
  ///
  /// 特定の[dateTime]もしくは現在時間と同じ年の場合は`true`を返します。
  bool isThisYear([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year;
  }

  /// Returns `true` if the time is the same as a specific [dateTime] or the current time.
  ///
  /// 特定の[dateTime]もしくは現在時間と同じ時刻の場合は`true`を返します。
  bool isThisHour([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour;
  }

  /// Returns `true` if the minute is the same as a specific [dateTime] or the current time.
  ///
  /// 特定の[dateTime]もしくは現在時間と同じ分の場合は`true`を返します。
  bool isThisMinute([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute;
  }

  /// Returns `true` if the second is the same as a specific [dateTime] or the current time.
  ///
  /// 特定の[dateTime]もしくは現在時間と同じ秒の場合は`true`を返します。
  bool isThisSecond([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour &&
        minute == dateTime.minute &&
        second == dateTime.second;
  }

  /// Parses [DateTime] to [String] by passing [format] corresponding to the Intl DateFormat.
  ///
  /// Describe the following pattern to define [format].
  ///
  /// IntlのDateFormatに対応した[format]を渡すことにより[DateTime]を[String]にパースします。
  ///
  /// 下記のパターンを記述して[format]を定義してください。
  ///
  ///     Symbol   Meaning                Presentation       Example
  ///     ------   -------                ------------       -------
  ///     G        era designator         (Text)             AD
  ///     y        year                   (Number)           1996
  ///     M        month in year          (Text & Number)    July & 07
  ///     L        standalone month       (Text & Number)    July & 07
  ///     d        day in month           (Number)           10
  ///     c        standalone day         (Number)           10
  ///     h        hour in am/pm (1~12)   (Number)           12
  ///     H        hour in day (0~23)     (Number)           0
  ///     m        minute in hour         (Number)           30
  ///     s        second in minute       (Number)           55
  ///     S        fractional second      (Number)           978
  ///     E        day of week            (Text)             Tuesday
  ///     D        day in year            (Number)           189
  ///     a        am/pm marker           (Text)             PM
  ///     k        hour in day (1~24)     (Number)           24
  ///     K        hour in am/pm (0~11)   (Number)           0
  ///     Q        quarter                (Text)             Q3
  ///     '        escape for text        (Delimiter)        'Date='
  ///     ''       single quote           (Literal)          'o''clock'
  ///
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return DateFormat(format).format(this).replaceAll(
          "ww",
          weekNumber.toString().padLeft(2, "0"),
        );
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// Outputs a string representing the day of the week.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// 曜日を表す文字列を出力します。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String E() {
    return format("E");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// The output will be in the format `2022/12`.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// `2022/12`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String yyyyMM() {
    return format("yyyy/MM");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// The output will be in the format `2022/12/21`.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// `2022/12/21`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String yyyyMMdd() {
    return format("yyyy/MM/dd");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// The output will be in the format `10:24:30`.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// `10:24:30`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  // ignore: non_constant_identifier_names
  String HHmmss() {
    return format("HH:mm:ss");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// The output will be in the format `10:24`.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// `10:24`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  // ignore: non_constant_identifier_names
  String HHmm() {
    return format("HH:mm");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// The output will be in the format `2022/12/21 10:24`.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// `2022/12/21 10:24`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String yyyyMMddHHmm() {
    return format("yyyy/MM/dd HH:mm");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  ///
  /// The output will be in the format `2022/12/21 10:24:30`.
  ///
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// `2022/12/21 10:24:30`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  ///
  /// 詳細は下記ページを参考にしてください。
  ///
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String yyyyMMddHHmmss() {
    return format("yyyy/MM/dd HH:mm:ss");
  }

  /// Create a new [DateTime] by extracting only the year and month from [DateTime].
  ///
  /// All hours, minutes, and seconds will be `0`.
  ///
  /// [DateTime]から年月日のみを抽出して新しい[DateTime]を作成します。
  ///
  /// 時刻分秒はすべて`0`になります。
  DateTime toDate() {
    return DateTime(year, month, day);
  }

  /// Converts from [DateTime] to a [String] of the form `20221223`.
  ///
  /// Available for path parameters, etc.
  ///
  /// [DateTime]から`20221223`のような形式の[String]に変換します。
  ///
  /// パスパラメーターなどに利用可能です。
  String toDateID() {
    return format("yyyyMMdd");
  }

  /// Converts from [DateTime] to a [String] of the form `20221223102331`.
  ///
  /// Available for path parameters, etc.
  ///
  /// [DateTime]から`20221223102331`のような形式の[String]に変換します。
  ///
  /// パスパラメーターなどに利用可能です。
  String toDateTimeID() {
    return format("yyyyMMddHHmmss");
  }

  /// Gets the ISO 8601 week number from [DateTime].
  ///
  /// For December 23, 2022, `51` is returned.
  ///
  /// [DateTime]からISO 8601に則った週番号を取得します。
  ///
  /// 2022年12月23日だと`51`が返されます。
  ///
  /// See below for details.
  ///
  /// 詳しくは下記を参照ください。
  ///
  /// https://en.wikipedia.org/wiki/ISO_8601
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

  /// Treats [DateTime], which is not defined as UTC due to parsing, as UTC and converts it to local time.
  ///
  /// パースの関係でUTCとして定義されていない[DateTime]をUTCとして扱いローカルタイムに変換します。
  DateTime toUnUtc() {
    return DateTime.tryParse("${toIso8601String().trimStringRight("Z")}Z")!
        .toLocal();
  }

  /// Returns the age at [today] (or current time) for the date.
  ///
  /// 日付に対しての[today]（もしくは現在時刻）における年齢を返します。
  ///
  /// ```dart
  /// final date = DateTime(1984, 8, 2).age(DateTime(2022, 10, 26)); // year: 38, month: 2, day: 24
  /// ```
  DateDuration age([DateTime? today]) {
    return _differenceDate(today ?? DateTime.now());
  }

  /// Returns the period until the next year date at [target] (or current time) for a date.
  ///
  /// 日付に対しての[target]（もしくは現在時刻）における次の年の日付までの期間を返します。
  ///
  /// ```dart
  /// final date = DateTime(1984, 8, 2).age(DateTime(2022, 10, 26)); // year: 38, month: 2, day: 24
  /// ```
  DateDuration dateToNextBirthday([DateTime? target]) {
    final endDate = target ?? DateTime.now();
    final tmpDate = DateTime(endDate.year, month, day);
    final nextBirthdayDate = tmpDate.isBefore(endDate)
        ? tmpDate._addDate(const DateDuration(1, 0, 0))
        : tmpDate;
    return endDate._differenceDate(nextBirthdayDate);
  }
}
