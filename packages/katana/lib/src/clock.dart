part of "/katana.dart";

/// A class that can be used instead of [DateTime].
///
/// You can set a fixed time during testing by using [setTestTime].
///
/// [DateTime]の代わりに使うことのできるクラス。
///
/// [setTestCurrentTime]を利用することで、テスト時に固定の時間を設定することができます。
class Clock extends DateTime {
  /// A class that can be used instead of [DateTime].
  ///
  /// You can set a fixed time during testing by using [setTestTime].
  ///
  /// [DateTime]の代わりに使うことのできるクラス。
  ///
  /// [setTestCurrentTime]を利用することで、テスト時に固定の時間を設定することができます。
  ///
  /// For example,
  /// to create a `Clock` object representing the 7th of September 2017,
  /// 5:30pm
  ///
  /// ```dart
  /// final dentistAppointment = Clock(2017, 9, 7, 17, 30);
  /// ```
  Clock(
    super.year, [
    super.month,
    super.day,
    super.hour,
    super.minute,
    super.second,
    super.millisecond,
    super.microsecond,
  ]);

  /// Constructs a [DateTime] instance specified in the UTC time zone.
  ///
  /// ```dart
  /// final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  /// ```
  ///
  /// When dealing with dates or historic events, preferably use UTC DateTimes,
  /// since they are unaffected by daylight-saving changes and are unaffected
  /// by the local timezone.
  ///
  /// UTC時間帯で指定された[DateTime]インスタンスを構築します。
  ///
  /// 日付や歴史的なイベントを扱う場合は、UTCの[DateTime]を使用することをお勧めします。
  /// なぜなら、夏時間の変更やローカルタイムゾーンの影響を受けないからです。
  Clock.utc(
    super.year, [
    super.month,
    super.day,
    super.hour,
    super.minute,
    super.second,
    super.millisecond,
    super.microsecond,
  ]) : super.utc();

  /// Returns a new [Clock] object representing the current date and time.
  ///
  /// If [setTestCurrentTime] is called, the returned [Clock] object will be
  /// the time set by [setTestCurrentTime].
  ///
  /// Returns a new [Clock] object representing the current date and time.
  ///
  /// 現在の日付と時刻を表す新しい[Clock]オブジェクトを返します。
  ///
  /// [setTestCurrentTime]が呼び出されている場合、[setTestCurrentTime]で設定された時刻の
  /// [Clock]オブジェクトが返されます。
  ///
  /// For example,
  /// to create a `Clock` object representing the current date and time,
  ///
  /// ```dart
  /// final now = Clock.now();
  /// ```
  factory Clock.now() {
    if (_testTime != null) {
      final testTime = _testTime!;
      return Clock(
        testTime.year,
        testTime.month,
        testTime.day,
        testTime.hour,
        testTime.minute,
        testTime.second,
        testTime.millisecond,
        testTime.microsecond,
      );
    }
    final now = DateTime.now();
    return Clock(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  /// Constructs a [DateTime] with the current UTC date and time.
  ///
  /// If [setTestCurrentTime] is called, the returned [Clock] object will be
  /// the time set by [setTestCurrentTime].
  ///
  /// 現在のUTC日付と時刻を表す新しい[Clock]オブジェクトを返します。
  ///
  /// [setTestCurrentTime]が呼び出されている場合、[setTestCurrentTime]で設定された時刻の
  /// [Clock]オブジェクトが返されます。
  ///
  /// ```dart
  /// final mark = DateTime.timestamp();
  /// ```
  factory Clock.timestamp() {
    if (_testTime != null) {
      final testTime = _testTime!.toUtc();
      return Clock(
        testTime.year,
        testTime.month,
        testTime.day,
        testTime.hour,
        testTime.minute,
        testTime.second,
        testTime.millisecond,
        testTime.microsecond,
      );
    }
    final now = DateTime.timestamp();
    return Clock(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  /// Creates a new [Clock] object from a [DateTime] object.
  ///
  /// DateTime オブジェクトから新しい Clock オブジェクトを作成します。
  ///
  /// For example,
  /// to create a `Clock` object from a `DateTime` object,
  ///
  /// ```dart
  /// final dentistAppointment = Clock.fromDateTime(DateTime(2017, 9, 7, 17, 30));
  /// ```
  factory Clock.fromDateTime(DateTime dateTime) {
    if (dateTime.isUtc) {
      return Clock.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond);
    }
    return Clock(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond);
  }

  /// Creates a new [Clock] object from a [DateTime] object.
  ///
  /// DateTime オブジェクトから新しい Clock オブジェクトを作成します。
  ///
  /// For example,
  /// to create a `Clock` object from a `DateTime` object,
  ///
  /// ```dart
  /// final dentistAppointment = Clock.fromDate(DateTime(2017, 9, 7));
  /// ```
  factory Clock.fromDate(DateTime date) {
    if (date.isUtc) {
      return Clock.utc(date.year, date.month, date.day, date.hour, date.minute,
          date.second, date.millisecond, date.microsecond);
    }
    return Clock(date.year, date.month, date.day, date.hour, date.minute,
        date.second, date.millisecond, date.microsecond);
  }

  /// Constructs a new [DateTime] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The accepted inputs are currently:
  ///
  /// * A date: A signed four-to-six digit year, two digit month and
  ///   two digit day, optionally separated by `-` characters.
  ///   Examples: "19700101", "-0004-12-24", "81030-04-01".
  /// * An optional time part, separated from the date by either `T` or a space.
  ///   The time part is a two digit hour,
  ///   then optionally a two digit minutes value,
  ///   then optionally a two digit seconds value, and
  ///   then optionally a '.' or ',' followed by at least a one digit
  ///   second fraction.
  ///   The minutes and seconds may be separated from the previous parts by a
  ///   ':'.
  ///   Examples: "12", "12:30:24.124", "12:30:24,124", "123010.50".
  /// * An optional time-zone offset part,
  ///   possibly separated from the previous by a space.
  ///   The time zone is either 'z' or 'Z', or it is a signed two digit hour
  ///   part and an optional two digit minute part. The sign must be either
  ///   "+" or "-", and cannot be omitted.
  ///   The minutes may be separated from the hours by a ':'.
  ///   Examples: "Z", "-10", "+01:30", "+1130".
  ///
  /// This includes the output of both [toString] and [toIso8601String], which
  /// will be parsed back into a `DateTime` object with the same time as the
  /// original.
  ///
  /// The result is always in either local time or UTC.
  /// If a time zone offset other than UTC is specified,
  /// the time is converted to the equivalent UTC time.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789z"`
  /// * `"2012-02-27 13:27:00,123456789z"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  ///
  /// This method accepts out-of-range component values and interprets
  /// them as overflows into the next larger component.
  /// For example, "2020-01-42" will be parsed as 2020-02-11, because
  /// the last valid date in that month is 2020-01-31, so 42 days is
  /// interpreted as 31 days of that month plus 11 days into the next month.
  ///
  /// To detect and reject invalid component values, use
  /// [DateFormat.parseStrict](https://pub.dev/documentation/intl/latest/intl/DateFormat/parseStrict.html)
  /// from the [intl](https://pub.dev/packages/intl) package.
  ///
  /// フォーマットされた文字列に基づいて新しい[Clock]インスタンスを構築します。
  ///
  /// 入力文字列がパースできない場合は[FormatException]をスローします。
  ///
  /// この関数はISO 8601のサブセットをパースし、RFC 3339で受け入れられるサブセットも含みます。
  ///
  /// 無効なコンポーネント値を検出して拒否するには、[intl](https://pub.dev/packages/intl)パッケージの
  /// [DateFormat.parseStrict](https://pub.dev/documentation/intl/latest/intl/DateFormat/parseStrict.html)
  /// を使用してください。
  static Clock parse(String formattedString) {
    final dateTime = DateTime.parse(formattedString);
    return Clock.fromDateTime(dateTime);
  }

  /// Constructs a new [DateTime] instance based on [formattedString].
  ///
  /// Works like [parse] except that this function returns `null`
  /// where [parse] would throw a [FormatException].
  ///
  /// フォーマットされた文字列に基づいて新しい[Clock]インスタンスを構築します。
  ///
  /// [parse]のように動作しますが、[parse]が[FormatException]をスローする場合に
  /// この関数は`null`を返します。
  static Clock? tryParse(String formattedString) {
    final dateTime = DateTime.tryParse(formattedString);
    if (dateTime == null) {
      return null;
    }
    return Clock.fromDateTime(dateTime);
  }

  /// Constructs a new [Clock] instance
  /// with the given [millisecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [Clock] represents
  /// 1970-01-01T00:00:00Z + [millisecondsSinceEpoch] ms in the given
  /// time zone (local or UTC).
  ///
  /// 指定された[millisecondsSinceEpoch]で新しい[Clock]インスタンスを構築します。
  ///
  /// [isUtc]がfalseの場合、日付はローカルタイムゾーンになります。
  ///
  /// 構築された[Clock]は、指定されたタイムゾーン（ローカルまたはUTC）で
  /// 1970-01-01T00:00:00Z + [millisecondsSinceEpoch] msを表します。
  ///
  /// ```dart
  /// final newYearsDay =
  ///     Clock.fromMillisecondsSinceEpoch(1641031200000, isUtc:true);
  /// print(newYearsDay); // 2022-01-01 10:00:00.000Z
  /// ```
  static Clock fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,
  }) {
    return Clock.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch,
        isUtc: isUtc,
      ),
    );
  }

  /// Constructs a new [Clock] instance
  /// with the given [microsecondsSinceEpoch].
  ///
  /// If [isUtc] is false, then the date is in the local time zone.
  ///
  /// The constructed [Clock] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  ///
  /// 指定された[microsecondsSinceEpoch]で新しい[Clock]インスタンスを構築します。
  ///
  /// [isUtc]がfalseの場合、日付はローカルタイムゾーンになります。
  ///
  /// 構築された[Clock]は、指定されたタイムゾーン（ローカルまたはUTC）で
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] usを表します。
  ///
  /// ```dart
  /// final newYearsEve =
  ///     Clock.fromMicrosecondsSinceEpoch(1640979000000000, isUtc:true);
  /// print(newYearsEve); // 2021-12-31 19:30:00.000Z
  /// ```
  static Clock fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    bool isUtc = false,
  }) {
    return Clock.fromDateTime(
      DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: isUtc,
      ),
    );
  }

  /// Sets the current time for testing.
  ///
  /// If [setTestCurrentTime] is called, the returned [Clock] object will be
  /// the time set by [setTestCurrentTime].
  ///
  /// 現在の時刻をテスト用に設定します。
  ///
  /// [setTestCurrentTime]が呼び出されている場合、[setTestCurrentTime]で設定された時刻の
  /// [Clock]オブジェクトが返されます。
  static setTestCurrentTime(DateTime? dateTime) {
    if (_testTime != dateTime) {
      _testTime = dateTime;
    }
  }

  static DateTime? _testTime;

  /// Monday.
  ///
  /// 月曜日。
  static const int monday = DateTime.monday;

  /// Tuesday.
  ///
  /// 火曜日。
  static const int tuesday = DateTime.tuesday;

  /// Wednesday.
  ///
  /// 水曜日。
  static const int wednesday = DateTime.wednesday;

  /// Thursday.
  ///
  /// 木曜日。
  static const int thursday = DateTime.thursday;

  /// Friday.
  ///
  /// 金曜日。
  static const int friday = DateTime.friday;

  /// Saturday.
  ///
  /// 土曜日。
  static const int saturday = DateTime.saturday;

  /// Sunday.
  ///
  /// 日曜日。
  static const int sunday = DateTime.sunday;

  /// The number of days in a week.
  ///
  /// 週の日数。
  static const int daysPerWeek = DateTime.daysPerWeek;

  /// January.
  ///
  /// 1月。
  static const int january = DateTime.january;

  /// February.
  ///
  /// 2月。
  static const int february = DateTime.february;

  /// March.
  ///
  /// 3月。
  static const int march = DateTime.march;

  /// April.
  ///
  /// 4月。
  static const int april = DateTime.april;

  /// May.
  ///
  /// 5月。
  static const int may = DateTime.may;

  /// June.
  ///
  /// 6月。
  static const int june = DateTime.june;

  /// July.
  ///
  /// 7月。
  static const int july = DateTime.july;

  /// August.
  ///
  /// 8月。
  static const int august = DateTime.august;

  /// September.
  ///
  /// 9月。
  static const int september = DateTime.september;

  /// October.
  ///
  /// 10月。
  static const int october = DateTime.october;

  /// November.
  ///
  /// 11月。
  static const int november = DateTime.november;

  /// December.
  ///
  /// 12月。
  static const int december = DateTime.december;

  /// The number of months in a year.
  ///
  /// 年の月数。
  static const int monthsPerYear = DateTime.monthsPerYear;

  @override
  Clock add(Duration duration) {
    return Clock.fromDateTime(super.add(duration));
  }

  @override
  Clock subtract(Duration duration) {
    return Clock.fromDateTime(super.subtract(duration));
  }

  @override
  Clock toLocal() {
    return Clock.fromDateTime(super.toLocal());
  }

  @override
  Clock toUtc() {
    return Clock.fromDateTime(super.toUtc());
  }
}
