part of katana;

/// Provides extended methods for [DateTime].
/// [DateTime]用の拡張メソッドを提供します。
extension DateTimeExtensions on DateTime {
  /// Returns `true` if the date is the same as a specific [dateTime] or the current time.
  /// 特定の[dateTime]もしくは現在時間と同じ日付の場合は`true`を返します
  bool isToday([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day;
  }

  /// Returns `true` if the month is the same as a specific [dateTime] or the current time.
  /// 特定の[dateTime]もしくは現在時間と同じ月の場合は`true`を返します。
  bool isThisMonth([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year && month == dateTime.month;
  }

  /// Returns `true` if the year is the same as a specific [dateTime] or the current time.
  /// 特定の[dateTime]もしくは現在時間と同じ年の場合は`true`を返します。
  bool isThisYear([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year;
  }

  /// Returns `true` if the time is the same as a specific [dateTime] or the current time.
  /// 特定の[dateTime]もしくは現在時間と同じ時刻の場合は`true`を返します。
  bool isThisHour([DateTime? dateTime]) {
    dateTime ??= DateTime.now();
    return year == dateTime.year &&
        month == dateTime.month &&
        day == dateTime.day &&
        hour == dateTime.hour;
  }

  /// Returns `true` if the minute is the same as a specific [dateTime] or the current time.
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
  /// IntlのDateFormatに対応した[format]を渡すことにより[DateTime]を[String]にパースします。
  ///
  /// Describe the following pattern to define [format].
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
  /// 詳細は下記ページを参考にしてください。
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return DateFormat(format).format(this).replaceAll(
          "ww",
          weekNumber.toString().padLeft(2, "0"),
        );
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// The output will be in the format `2022/12/21`.
  /// `2022/12/21`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  /// 詳細は下記ページを参考にしてください。
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String yyyyMMdd() {
    return format("yyyy/MM/dd");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// The output will be in the format `10:24:30`.
  /// `10:24:30`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  /// 詳細は下記ページを参考にしてください。
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  // ignore: non_constant_identifier_names
  String HHmmss() {
    return format("HH:mm:ss");
  }

  /// Parse from [DateTime] to [String] corresponding to an Intl DateFormat.
  /// [DateTime]からIntlのDateFormatに対応した[String]にパースします。
  ///
  /// The output will be in the format `2022/12/21 10:24:30`.
  /// `2022/12/21 10:24:30`のような形式で出力されます。
  ///
  /// Please refer to the following page for details.
  /// 詳細は下記ページを参考にしてください。
  /// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  String yyyyMMddHHmmss() {
    return format("yyyy/MM/dd HH:mm:ss");
  }

  /// Create a new [DateTime] by extracting only the year and month from [DateTime].
  /// [DateTime]から年月日のみを抽出して新しい[DateTime]を作成します。
  ///
  /// All hours, minutes, and seconds will be `0`.
  /// 時刻分秒はすべて`0`になります。
  DateTime toDate() {
    return DateTime(year, month, day);
  }

  /// Converts from [DateTime] to a [String] of the form `20221223`.
  /// [DateTime]から`20221223`のような形式の[String]に変換します。
  ///
  /// Available for path parameters, etc.
  /// パスパラメーターなどに利用可能です。
  String toDateID() {
    return format("yyyyMMdd");
  }

  /// Converts from [DateTime] to a [String] of the form `20221223102331`.
  /// [DateTime]から`20221223102331`のような形式の[String]に変換します。
  ///
  /// Available for path parameters, etc.
  /// パスパラメーターなどに利用可能です。
  String toDateTimeID() {
    return format("yyyyMMddHHmmss");
  }

  /// Gets the ISO 8601 week number from [DateTime].
  /// [DateTime]からISO 8601に則った週番号を取得します。
  ///
  /// For December 23, 2022, `51` is returned.
  /// 2022年12月23日だと`51`が返されます。
  ///
  /// See below for details.
  /// 詳しくは下記を参照ください。
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
  /// パースの関係でUTCとして定義されていない[DateTime]をUTCとして扱いローカルタイムに変換します。
  DateTime toUnUtc() {
    return DateTime.tryParse("${toIso8601String().trimStringRight("Z")}Z")!
        .toLocal();
  }
}
