part of katana_flutter;

/// Provides localize extensions to [String].
extension LocalizeStringExtensions on String {
  /// Get translated text.
  ///
  /// By specifying [language], you can translate in a specific language.
  ///
  /// If [language] is specified and the specified language is not available,
  /// the translation will be performed in English.
  String localize({String? language}) => Localize.get(
        this,
        defaultValue: this,
        language: language,
      );

  /// Convert to type [List<List<dynamic>>] for CSV.
  List<List<dynamic>> toCSVList([
    List<List<dynamic>> defaultValue = const [],
  ]) {
    final csv = replaceAll("\r\n", "\n").replaceAll("\r", "\n");
    return const CsvToListConverter().convert(csv, eol: "\n");
  }

  /// Convert to type [DynamicMap] for CSV.
  List<DynamicMap> toCSVMap([
    List<DynamicMap> defaultValue = const [],
  ]) {
    final list = toCSVList();
    if (list.length <= 1) {
      return defaultValue;
    }
    final res = <DynamicMap>[];
    final labels = list[0];
    for (int i = 1; i < list.length; i++) {
      final line = list[i];
      final map = <String, dynamic>{};
      for (int j = 0; j < line.length; j++) {
        if (labels.length <= j) {
          break;
        }
        final key = labels[j];
        map[key] = line[j];
      }
      res.add(map);
    }
    return res;
  }
}

/// Provides general extensions to [String?].
extension NullableLocalizeStringExtensions on String? {
  /// Get translated text.
  String localize(String defaultValue) {
    if (this == null) {
      return defaultValue;
    }
    return Localize.get(this!, defaultValue: this!);
  }

  /// Convert to type [List<List<dynamic>>] for CSV.
  List<List<dynamic>> toCSVList([
    List<List<dynamic>> defaultValue = const [],
  ]) {
    if (this == null) {
      return defaultValue;
    }
    final csv = this!.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
    return const CsvToListConverter().convert(csv, eol: "\n");
  }

  /// Convert to type [DynamicMap] for CSV.
  List<DynamicMap> toCSVMap([
    List<DynamicMap> defaultValue = const [],
  ]) {
    if (this == null) {
      return defaultValue;
    }
    final list = toCSVList();
    if (list.length <= 1) {
      return defaultValue;
    }
    final res = <DynamicMap>[];
    final labels = list[0];
    for (int i = 1; i < list.length; i++) {
      final line = list[i];
      final map = <String, dynamic>{};
      for (int j = 0; j < line.length; j++) {
        if (labels.length <= j) {
          break;
        }
        final key = labels[j];
        map[key] = line[j];
      }
      res.add(map);
    }
    return res;
  }
}

/// Provides flutter extensions to [DateTime].
extension FlutterDateTimeExtensions on DateTime {
  /// Gets the localized week.
  String get localizedWeekDay => "WeekDay${weekday.toString()}".localize();

  /// Gets the localized week.
  String get shortLocalizedWeekDay => "Week${weekday.toString()}".localize();

  /// Only time is extracted.
  TimeOfDay toTime() {
    return TimeOfDay.fromDateTime(this);
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  DateTime combine(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

/// Provides general extensions to [Color].
extension ColorExtensions on Color {
  /// Makes the color darker.
  ///
  /// The higher the value(0.0 - 1.0), the darker the image becomes.
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Makes the color lighter.
  ///
  /// The higher the value(0.0 - 1.0), the lighter the image becomes.
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

/// Extended method of listing for CSV.
extension CSVListExtensions on List<List<dynamic>> {
  /// Convert to string for CSV.
  String toCSVString() {
    return const ListToCsvConverter().convert(this, eol: "\n");
  }
}

/// Extension methods for DynamicMap listings.
extension ListOfDynamicMapExtensions on List<DynamicMap> {
  /// Convert to type [List<List<dynamic>>] for CSV.
  List<List<dynamic>> toCSVList() {
    final labels = <String>[];
    final res = <List<dynamic>>[];
    for (final line in this) {
      for (final tmp in line.entries) {
        if (labels.contains(tmp.key)) {
          continue;
        }
        labels.add(tmp.key);
      }
    }
    res.add(labels);
    for (final line in this) {
      final tmp = [];
      for (final key in labels) {
        if (!line.containsKey(key)) {
          continue;
        }
        tmp.add(line[key]);
      }
      res.add(tmp);
    }
    return res;
  }

  /// Convert to CSV string.
  String toCSVString() {
    return toCSVList().toCSVString();
  }
}
