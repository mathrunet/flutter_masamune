part of katana_flutter;

/// Class to translate.
///
/// Execute the [initialize()] method and load the csv file.
///
/// ```
/// await Localize.initialize();
/// ```
///
/// After that, display the translated text by executing the [get()] method.
///
/// ```
/// final localizeName = Localize.get("Name");
/// ```
class Localize {
  Localize._();

  static const String _defaultLoacle = "en_US";
  static final Map<String, Map<String, String>> _collection = {};
  static Map<String, String>? get _document {
    __document ??= _collection[language];
    return __document;
  }

  static Map<String, String>? __document;

  /// Language settings for translation.
  static String get language {
    if (_language.isNotEmpty) {
      return _language;
    }
    _language = locale.split("_").first;
    __document = _collection[_language];
    return _language;
  }

  /// Language locale setting.
  static String get locale {
    if (_locale.isNotEmpty) {
      return _locale;
    }
    return _defaultLoacle;
  }

  /// Language locale setting.
  ///
  /// [locale]: Locale.
  static set locale(String locale) {
    _locale = locale;
    _language = locale.split("_").first;
    __document = _collection[language];
    Prefs.set("locale://".toSHA1(), _locale);
  }

  static String _locale = "";
  static String _language = "";

  /// True if initialization has been completed.
  static bool get isInitialized => _isInitialized;
  // ignore: prefer_final_fields
  static bool _isInitialized = false;

  /// Get translated text.
  ///
  /// Get the translation by specifying the [key].
  ///
  /// By specifying [defaultValue],
  /// you can determine the value if [key] is not found.
  ///
  /// By specifying [language], you can translate in a specific language.
  ///
  /// If [language] is specified and the specified language is not available,
  /// the translation will be performed in English.
  static String get(String key, {String? defaultValue, String? language}) {
    if (language.isNotEmpty) {
      final document =
          _collection[language] ?? _collection[_defaultLoacle.split("_").first];
      if (!(document?.containsKey(key) ?? false)) {
        return defaultValue ?? key;
      }
      return document?[key] ?? defaultValue ?? key;
    } else {
      if (!(_document?.containsKey(key) ?? false)) {
        return defaultValue ?? key;
      }
      return _document?[key] ?? defaultValue ?? key;
    }
  }

  /// Initialize localization.
  ///
  /// You can specify the asset path of the Localization file in [path].
  static Future<void> initialize({
    String path = "assets/Localization.csv",
    Duration timeout = const Duration(seconds: 5),
    String? locale,
  }) async {
    try {
      if (isInitialized) {
        return;
      }
      if (path.isEmpty) {
        debugPrint("CSV File path is empty.");
        return Future.error("CSV File path is empty.");
      }
      String csv = await rootBundle.loadString(path).timeout(timeout);
      if (csv.isEmpty) {
        debugPrint("CSV data is empty.");
        return Future.error("CSV data is empty.");
      }
      final num2lang = <int, String>{};
      csv = csv.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
      final converted = const CsvToListConverter().convert(csv, eol: "\n");
      for (int y = 1; y < converted.length; y++) {
        final line = converted[y];
        if (line.isEmpty) {
          continue;
        }
        for (int x = 1; x < line.length; x++) {
          final cell = line[x];
          if (cell.isEmpty) {
            continue;
          }
          if (y == 1) {
            final langs = cell.split(":");
            _collection[langs.first] = {};
            num2lang[x - 1] = langs.first;
          } else {
            final key = line.first;
            final val = line[x];
            if (val.isEmpty || key.isEmpty || key.startsWith("#")) {
              continue;
            }
            final doc = _collection[num2lang[x - 1]] ?? {};
            doc[key] = val;
          }
        }
      }
    } catch (e) {
      print("[$path] was not found.");
    }
    final deviceLocale = Config.locale;
    if (deviceLocale.isEmpty) {
      return;
    }
    if (locale.isEmpty) {
      _locale = Config.isMobile
          ? deviceLocale
          : Prefs.getString("locale://".toSHA1(), deviceLocale);
      if (_locale.isEmpty) {
        _locale = "en_US";
      }
      initializeDateFormatting(_locale);
      _language = _locale.split("_").first;
    } else {
      _locale = locale!;
      Prefs.set("locale://".toSHA1(), _locale);
      initializeDateFormatting(locale);
      _language = _locale.split("_").first;
    }
    if (_collection.containsKey(_language)) {
      __document = _collection[_language];
    }
    _isInitialized = true;
  }
}
